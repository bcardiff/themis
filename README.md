# Themis

[![Creative Commons License](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

Themis by [Brian J. Cardiff](https://github.com/bcardiff) is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).
Based on a work at [https://github.com/bcardiff/themis](https://github.com/bcardiff/themis).


## Docker development environment

Install docker and docker-compose.

Run:

```
$ ./dev-setup.sh
$ docker-compose up
```

Open `http://localhost:3000`.

### First time

Register a user from the login form in the web.

```
$ docker-compose exec app rails console
   > u = User.first
   > u.admin = true
   > u.save!
   > exit
```

Reload the web page.

### Mailing

Open `http://localhost:3080` to see the emails sent from the app during development.

### Running specs

To run specs `$ docker-compose exec app rspec`.

A selenium can be accessed via vnc at `localhost:5901` (password: secret).

When restoring a backup, you can reset user password doing

### Restore backups

```
$ docker-compose exec app rake db:drop db:create
$ docker-compose exec db bash
   # mysql -u root themis_development < ./path/to/backup.sql
$ docker-compose exec app /bin/bash -c "USER=email@domain.com PASSWORD=newpassword rake app:reset_pwd"
```

Note: If the `backup.sql` is stored in this project folder, then `/src/backup.sql` is the path to use.
