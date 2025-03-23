from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv
from urllib.parse import quote_plus
import os

load_dotenv()


class Database:
    db_name = os.getenv("APP_DB_NAME")
    def __init__(self):
        self.mongo_uri = os.getenv("APP_DB_URI")
        self.client = MongoClient(self.mongo_uri, server_api=ServerApi("1"))
        self.db = self.client[self.db_name]
        
    def server_ping(self):
        try :
            return self.client.server_info()
        except Exception as e:
            return str(e)
    
    def get_collection(self, collection_name):
        return self.db[collection_name]
        
    
    
