import pandas as pd
import numpy as np

#age = age + 30
#sex: 1 - male, 0 - female
#Fare = Fare + 35





def get_data():
    train = pd.read_csv('train.csv')
    train = train.drop(columns=["PassengerId"]).values.astype(np.float32)
    return train

def get_answers():
    survival = pd.read_csv("survivaldata.csv")
    answers = survival["Survived"].values.tolist()
    return answers

def get_passenger_id():
    ids = pd.read_csv("survivaldata.csv")
    ids = ids["PassengerId"].values.tolist()
    return ids

def write_performance(performance):
    df = pd.DataFrame({"Epoch":list(map(lambda x: x+1, range(len(performance)))), "Performance":performance})
    df.to_excel("performance.xlsx")

def write_predictions(predictions):
    df = pd.DataFrame({"PassengerId":get_passenger_id(), "Prediction":predictions})
    df.to_excel("predictions.xlsx")


#def write_predictions(predictions):
    #df = pd.DataFrame({"PassengerID":list(map(lambda x: x+1, range(len(predictions)))),"Survived":predictions})
    #df.to_excel("predictions.xlsx")
