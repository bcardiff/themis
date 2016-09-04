# Themis

[![Creative Commons License](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

Themis by [Brian J. Cardiff](https://github.com/bcardiff) is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).
Based on a work at [https://github.com/bcardiff/themis](https://github.com/bcardiff/themis).

## Development

Install `rbenv`, `mysql` (user: root/password: blank).

```
$ rbenv install 2.2.5
$ ruby --version
ruby 2.2.5p319 (2016-04-26 revision 54774) [x86_64-darwin15]
$ gem install bundler
$ rbenv rehash
$ bundle install
$ rbenv rehash
$ rake db:create db:schema:load db:seeds
$ rails s
```

Open `http://localhost:3000`.

To run specs `$ rspec`.

When restoring a backup, you can reset user password doing

```
$ rake db:drop db:create
$ mysql -u root themis_development < ~/path/to/backup.sql
$ USER=email@domain.com PASSWORD=newpassword rake app:reset_pwd
```

