# podsearch

LIVE DEMO - https://podsearch.herokuapp.com/

Install postgres...

createuser -P dancer

Enter password for new role: dance

createdb -O dancer podsearch

psql -U dancer -W podsearch -f podsearch.sql

we have issues with stop words functions/methods are often short words, and by default tsquery uses a built in stop word dictionary.

errorr -- text-search query contains only stop words or doesn't contain lexemes, ignored

for now lets override it with an empty dictionary  - no_stop_words.sql

CREATE TEXT SEARCH DICTIONARY english_stem_nostop (
    Template = snowball,
    Language = english
);

"CREATE TEXT SEARCH CONFIGURATION public.english_nostop ( COPY = pg_catalog.english );
ALTER TEXT SEARCH CONFIGURATION public.english_nostop
   ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, hword, hword_part, word WITH english_stem_nostop;"

...................

plackup bin/app.psgi

First search box accepts a Module name ie. HTML::SocialMeta ;)

then you can run  - 

psql podsearch

\x - expanded display is on

select * from pod;

...................

lots of TODOs
