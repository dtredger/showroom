##Showspace

Showspace is a pretty standard Rails 4.1 crud app that allows users to view items in a
grid interface and save them to a "closet". Users can have multiple named closets.
Uses Devise for authentication, carrierwave for images (uploaded to s3), rspec +
FactoryGirl for tests. Tests are mostly around Model and controller tests (only a
few request specs, since we aren't really settled on the ui).

- master branch on heroku at http://showspace-staging.herokuapp.com/

####Workflow
Using a Git Flow (-ish) strategy: feature branches are merged into develop when they
are complete. Not bothering with Release branches for now, just periodically merging
develop into master so the default page on Github isn't too far behind where the
project really is. Trello board for to-dos.


####Scrapers
Items are harvested via scraper. Currently there are three custom scrapers, but
they all inherit basic functionality from a BasicScraper class. The scrapers are
run as rake tasks. For now they will be run locally, but connected to the live
database (wherever it lives: currently heroku).
When items are created, their attributes are checked against existing items (name,
price, designer, etc), and given a "match score" based on similarity. This score
is accessible in the admin interface, so an admin can verify whether the items
created are duplicates or new.


####Admin Interface
Uses Active Admin for the default admin dashboard. Does not allow creating admin
users or items. The main focus is allowing an admin to change the "state" of an
item. When items are first scraped, they are given a "pending" status, and will
not be shown until they are set "live". Admin dashboard also allows batch deletes
of items that have duplicate-warnings, so you can easily remove a bunch of new
scraped items that are the same as existing items.
