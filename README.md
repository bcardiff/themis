# Themis

[![Creative Commons License](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

Themis by [Brian J. Cardiff](https://github.com/bcardiff) is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).
Based on a work at [https://github.com/bcardiff/themis](https://github.com/bcardiff/themis).


## Docker development environment

Install docker and docker-compose.

Run:

```
$ ./dev-setup.sh
```

Open `http://localhost:3000`.

To run specs `$ docker-compose exec app rspec`.

A selenium can be accessed via vnc at `localhost:5901` (password: secret).

When restoring a backup, you can reset user password doing

```
$ docker-compose exec app rake db:drop db:create
$ docker-compose exec db bash
   # mysql -u root themis_development < ./path/to/backup.sql
$ docker-compose exec app /bin/bash -c "USER=email@domain.com PASSWORD=newpassword rake app:reset_pwd"
```
