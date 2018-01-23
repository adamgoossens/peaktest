A simple Falcon API that returns random response codes.

Simply install `falcon` and `gunicorn` and start the API:

```
gunicorn --bind 0.0.0.0:8000 testapi:api
```

Now whenever you access http://localhost:8000, a random response code will be generated:

```
$ curl -w %{http_code} http://localhost:8000
400
```
