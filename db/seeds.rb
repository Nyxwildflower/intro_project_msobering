require "net/http"
require "json"

Artwork.destroy_all
Artist.destroy_all
Category.destroy_all
Exhibition.destroy_all

# This file runs for 9.48 minutes due to the use of the sleep function to avoid
# my being emailed about "too many requests". You have been warned.

# The artwork data is included with the exhibition request, but is stil
# described as a different dataset in the "about page".
# The artist endpoint was moved further down so the ids are reset every loop.
exhibition_endpoint = "https://api.artic.edu/api/v1/exhibitions?page=1"
exhibition_fields = "&fields=id,title,gallery_title,short_description,aic_start_at,aic_end_at,artwork_ids&include=artworks"
image_endpoint = "https://www.artic.edu/iiif/2/"

# Converts the given endpoint to a uri, sends the request, and returns
# the response in a format readable by Ruby.
def request_data(url)
  uri = URI(url)

  # Create a request that uses an AIC-User-Agent header.
  # This is requested in the API documentation.
  headers = {"AIC-User-Agent" => "intro-project (madisonsobering@gmail.com)"}

  response = Net::HTTP.get(uri, headers)
  formatted_response = JSON.parse(response)
end

# Stop when Artworks and Artists collectively make up the row count.
# This number is a safe estimate.
3.times do |i|
  exhibition_endpoint = exhibition_endpoint.chop + (i + 1).to_s
  exhibition_url = exhibition_endpoint + exhibition_fields
  exhibition_response = request_data(exhibition_url)

  collected_artist_ids = []

  exhibition_response["data"].each do |exhibit|
    # Some exhibits had a ridiculous amount of artworks, so I've avoided them
    # with a maxmimum limit of 50.
    if exhibit["artwork_ids"][0] != nil && exhibit["artwork_ids"].count <= 50
      exhibit_association = Exhibition.find_or_create_by!(title:            exhibit["title"],
                                                          description:      exhibit["short_description"],
                                                          exhibition_start: exhibit["aic_start_at"],
                                                          exhibition_end:   exhibit["aic_end_at"],
                                                          gallery_title:    exhibit["gallery_title"])

      exhibit["artworks"].each do |art|
        # The "thumnail" section only exists for some artworks, so the alt_text
        # field is inaccesible in some cases.
        alt_text = art["thumbnail"] ? art["thumbnail"]["alt_text"] : "null"

        artwork = Artwork.find_or_create_by!(title:           art["title"],
                                             year:            art["date_display"],
                                             medium:          art["medium_display"],
                                             place_of_origin: art["place_of_origin"],
                                             dimensions:      art["dimensions"],
                                             description:     art["description"],
                                             alt_text:        alt_text,
                                             api_id:          art["artist_id"])

        artwork.exhibitions << exhibit_association

        # Attach the associated image using Active Storage.
        if !art["image_id"].blank?
          # Add the identifier from the artwork and specify the region/size/rotation/quality.
          image_url = image_endpoint + art["image_id"]

          image_request = image_url + "/info.json"

          check_image_max_size = request_data(image_request)

          if check_image_max_size["width"] < 843
            image_url += "/full/400,/0/default.jpg"
          else
            image_url += "/full/843,/0/default.jpg"
          end

          # Leave time between requests.
          sleep 3
          uri = URI.parse(image_url)
          image = URI.open(uri, "AIC-User-Agent" => "intro-project (madisonsobering@gmail.com)")

          artwork.image.attach(io: image, filename: art["image_id"], content_type: "image/jpeg")
        end

        # Create the associated categories.
        art["category_titles"].each do |category_name|
          category_association = Category.find_or_create_by!(title: category_name)
          artwork.categories << category_association
        end

        # Append all the artist ids to the url to avoid a large number of requests.
        unless art["artist_ids"].count == 0 then collected_artist_ids.append(art["artist_id"]) end
      end
    end
  end

  # I needed to reduce the amount of artist ids used in each request, so this
  # is my way of batching them and adding them to the records.
  until collected_artist_ids.count == 0
    artist_endpoint = "https://api.artic.edu/api/v1/artists?fields=id,title,birth_date,death_date,description&ids="

    # Add a maximum of 30 ids, and remove them from the array after.
    30.times do
      artist_endpoint += "#{collected_artist_ids[0]},"
      collected_artist_ids.shift

      if collected_artist_ids.count == 0
        break
      end
    end

    # Get artist information and store in the database. Use chop to remove the extra comma.
    artist_response = request_data(artist_endpoint.chop)

    artist_response["data"].each do |artist_information|
      # Avoid duplicate records of artists.
      artist_association = Artist.find_or_create_by!(title:       artist_information["title"],
                                                     birth_date:  artist_information["birth_date"],
                                                     death_date:  artist_information["death_date"],
                                                     description: artist_information["description"])

      # Find artworks without associated artists to save time on future loops.
      artworks = Artwork.all.where.missing(:artist)

      # Associate artworks to their respective artists.
      artworks.each do |artwork_association|
        if artwork_association.api_id == artist_information["id"]
          artist_association.artworks << artwork_association
        end
      end
    end
  end
end