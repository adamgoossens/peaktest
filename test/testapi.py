import falcon
import random

class random_response():
    def on_get(self,req,resp):
        codes = [200,201,202,203,301,302,400,401,403,404,500,501,503]
        random_code = random.choice(codes)
        resp.status=getattr(falcon,"HTTP_%d" % random_code)

api = falcon.API()
random_route = random_response()
api.add_route('/', random_route)
