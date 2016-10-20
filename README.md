# CoverImages
[![Build Status](https://travis-ci.org/uvalib/CoverImages.svg?branch=master)](https://travis-ci.org/uvalib/CoverImages)

CoverImages is a web service for retrieving cover images for books, music albums, DVDs, and other media.

## Dependencies
* Ruby-2.3.1
* Redis for sidekiq workers
* ImageMagick for [paperclip](https://github.com/thoughtbot/paperclip) processing
* Mysql

## Config
server config is kept in `.env`.

`.env.production` will override `.env` when RAILS_ENV=production.

For development, only the api keys are required.

## Admin Access
The admin panel uses UVa's Netbadge authorization. Apache must be configured for this.
Authorized users need to be listed in `config/authorized_users.yml`.

Admins can perform CRUD actions on all cover images. Including manual creation with a solr id.
The workers link shows the built-in sidekiq/background job dashboard.

## Cover Image Services
In order by priority. If no image is found from a source, we use the next one.
Each service has it's own rate limits, defined in `app/workers/*`

#### Books
* [Google Books](https://developers.google.com/books/docs/static-links)
* [LibraryThing](http://blog.librarything.com/main/2008/08/a-million-free-covers-from-librarything/)
* Syndetics (undocumented)
* [OpenLibrary](https://openlibrary.org/dev/docs/api/covers)

#### Music
* [Last.fm](http://www.last.fm/api)
* [MusicBrainz](https://beta.musicbrainz.org/doc/Cover_Art_Archive/API#.2Frelease.2F.7Bmbid.7D.2F)

## API

GET `/cover_images/[solr_id].json` is the only public endpoint.

| Query Param | Values             | Required       |
| ----------- | ------             | --------       |
| doc_type    | music or non_music | yes            |
| title       |                    | no             |
| isbn        |                    | *              |
| oclc        |                    | *              |
| lccn        |                    | *              |
| upc         |                    | *              |
| mbid        |                    | no             |
| artist_name |                    | yes, for music |
| album_name  |                    | yes, for music |
\* At least one of the starred ids is required for books.

Returns JSON. A default image is sent if the resord has not been processed yet.

```
{
  image_base64: [Base64 encoded image],
  not_found: [true,false],
  errors: [Error String]
}
```


## Tests
Rails 5 with minitest: `rails test`

The [VCR gem](https://github.com/vcr/vcr) is used to record and play back api responses for testing.
To record new responses (if an api changes) run `rm -rf test/fixtures/vcr_cassettes` and the next `rails test` will make real api requests.


## Deployment
`cap production deploy`

[Capistrano](https://github.com/capistrano/capistrano) handles deployments and restarting puma, sidekiq.
`config/deploy.rb` and `config/deploy/[staging,production].rb` have the details.

Most config files including .env, database.yml, authorized_users.yml and the actual cover images located at `public/system` are located in `[deploy_path]/shared` and symlinked to the `[deploy_path]/current` folder during deployment.

Anything that is server specific and preserved between deployments should be in a capistrano linked file.

