# podsearch

Install postgres...

createuser -P dancer

Enter password for new role: dance

createdb -O dancer podsearch

psql -U dancer -W podsearch -f podsearch.sql

...................

still can't search but you can generate a db of pod.

plackup bin/app.psgi

First search box accepts a Module name ie. HTML::SocialMeta ;)

then you can run  - 

psql podsearch

\x - expanded display is on

select * from pod;

...................
