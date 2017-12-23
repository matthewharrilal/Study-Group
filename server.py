
from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from bson.objectid import ObjectId
import bcrypt
import json
from CustomClass import JSONEncoder
from flask import jsonify
import pdb
from bson import BSON
from bson import json_util
from basicauth import decode
from bson.json_util import dumps

app = Flask(__name__)
client = MongoClient('mongodb://localhost:27017/')
app.db = client.StudyGroupsApplication
database = app.db
rounds = app.bcrypt_rounds = 5
api = Api(app)
study_group_collection = database.study_groups

def authenticated_request(func):
    def wrapper(*args, **kwargs):
        auth = request.authorization
        auth_code = request.headers['authorization']
        email, password = decode(auth_code)
        if email is not None and password is not None:
            user_collection = database.posts
            user = user_collection.find_one({'email': email})
            if user is not None:
                encoded_password = password.encode('utf-8')
                if bcrypt.checkpw(encoded_password, user['password']):
                    return func(*args, **kwargs)
                else:
                    return ({'error': 'email or password is not correct'}, 401, None)
            else:
                return ({'error': 'could not find user in the database'}, 400, None)
        else:
            return ({'error': 'enter both email and password'}, 400, None)

    return wrapper


class User(Resource):
    '''This function is what essentially gives us the ability sign a user up as well as post resources
    to our database in addition we do not need to wrap this post function in the decorator due to the fact that
    we dont need authorization when we first sign up we just need to post resources to the database'''
    def post(self):

        # Access the resources that the user is sending us through the json
        requested_json = request.json

        # Now that we have the json we want to see if the neccesary requirements are in there but first we have
        # to realize that the first time the post function gets called is when the user signs up therefore we have to
        # hash their passwords so that the user can be able to log in again if they ever log out
        users_password = requested_json.get('password')

        # Boiler Plate code to store the users password in the database as a hashed binary password
        encoded_password = users_password.encode('utf-8')
        hashed_password = bcrypt.hashpw(encoded_password, bcrypt.gensalt(rounds))

        # Then update the value in that json with the new hashed password as oppose to the unhashed non safe version
        requested_json['password'] = hashed

        if 'email' and 'password' in requested_json:
            study_group_collection.insert_one(requested_json)
            requested_json.pop('password')
            print('The user has been succesfully inserted')
            return(requested_json, 201, None)

    @authenticated_request
    def get(self):
        '''This function serves the purpose of fetching the user or in terms of the client it serves the 
        purpose of the user logging in because when a user loggin in we are essentially fetching their credentials
        which is a get request'''

        # If they are logging in they are loggin in with verified credentials therefore we know we pass credentials
        # through the headers therefore we have to access their credentials in the headers that were sent
        auth = request.authorization

        # Now that we have the credentials we have to see if the user actually exists in the database
        # therefore we have to find the user
        user_find = study_group_collection.find_one({'email': auth.username})

        # Now we check if we actually got results back from the search for that user
        if user_find is not None:
            # If the results aren't nil that means we actually got a user back therefore what we want to do 
            # pop the passwords so that doesnt get sent back with us

            # And on a side not the decorator handles verifing the user when we search for the user in the database
            user_find.pop('password')
            print("The user has succesfully been fetched")
            return(user_find, 200 , None)
    

        



if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)