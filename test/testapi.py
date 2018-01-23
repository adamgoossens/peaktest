import falcon
import random

class RandomResponse():
    def on_get(self,req,resp):
        codes = [200,201,202,203,301,302,400,401,403,404,500,501,503]
        random_code = random.choice(codes)
        resp.status=getattr(falcon,"HTTP_%d" % random_code)

api = falcon.API()
api.add_route('/', RandomResponse())
