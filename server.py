
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
user_collection = database.users

def authenticated_request(func):
    def wrapper(*args, **kwargs):
        auth = request.authorization
        print('***********')
        print(request.authorization)
        print('***********')
        auth_code = request.headers['authorization']
        email,password = decode(auth_code)

        if email is not None and password is not None:
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
        requested_json['password'] = hashed_password

        if 'email' and 'password' in requested_json:
            user_collection.insert_one(requested_json)
            requested_json.pop('password')
            print('The user has been succesfully inserted')
            return(requested_json, 201, None)

    @authenticated_request
    def get(self):
        # This is essentially the function that we are going to be using to fetch the users

        # Since we are fetching users we have to take whatever the user
        auth = request.authorization
        user_find = user_collection.find_one({'email': auth.username})

        encoded_password = auth.password.encode('utf-8')

        # Now we esentially implement the error handling
        if bcrypt.checkpw(encoded_password, user_find['password']) is not None:
            user_find.pop('password')
            print('The user has succesfully been fetched')
            return (user_find, 200, None)
        else:
            print("The user could not be fetched")
            return (None, 401, None)


class University(Resource):

    # This function is essentially going to be the function that takes care of adding the university name
    @authenticated_request
    def post(self):
        # So this function is what is going to take care of posting the univeristy to the database

        # So we have to create a new collection that holds the universities
        university_collection = database.university

        # Now that we have the university collection we have to write the boiler plate code to see if the user is logged in
        auth = request.authorization

        # As well as the resources that the user is trying to send over
        request_json = request.json

        # Now that we have access to the headers we have to see if the account even exists first
        account_find = user_collection.find_one({'email': auth.username})

         # Now that we have the account we have to verify that it actually exists but we have to verify that the user is logged in
        encoded_password = auth.password.encode('utf-8')

        if bcrypt.checkpw(encoded_password, account_find['password']) and 'university_name' in request_json:
            university_collection.insert_one(request_json, auth.username)
            return request_json

    @authenticated_request
    def get(self):

        university_collection = database.university
        # This function is what we are going to be using to fetching the university for the user that is logged in
        # So first we have to verify that the user is actually logged in
        auth = request.authorization

        user_account_find = user_collection.find_one({'email': auth.username})

        encoded_password = auth.password.encode('utf-8')

        university_find = university_collection.find_one({'email': auth.username})

        if bcrypt.checkpw(encoded_password, user_account_find['password']) and university_find is not None:
            print('The user has been returned their university')
            return university_find, 200, None

class StudyGroup(Resource):
    @authenticated_request
    def post(self):
        # This function serves the purpose of posting resources to the database therefore we are going to need access to the collection\
        auth = request.authorization

        request_json = request.json

        university_collection = database.university

        user_account_find = user_collection.find_one({'email': auth.username})

        university_find = university_collection.find_one({'email': auth.username})

        study_group_collection = database.study_groups

        # Now that we have the account we have to actually verify if the account exists from there in addition to making sure
        # that the user is logged in
        encoded_password = auth.password.encode('utf-8')

        # Checks for two things make sure that the user is logged in as well as they have provided a university
        if bcrypt.checkpw(encoded_password, user_account_find['password']) and university_find is not None:
            print("The user has posted a study group")
            study_group_collection.insert_one(request_json)
            return request_json, 201, None




api.add_resource(User, '/users')
api.add_resource(University, '/university')
api.add_resource(StudyGroup, '/study_groups')

@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp
# Encodes our resouces for us


if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)