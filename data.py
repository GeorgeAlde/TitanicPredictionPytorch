import pandas as pd

#age = age + 30
#sex: 1 - male, 0 - female
#Fare = Fare + 35





def get_data():
    train = pd.read_csv('train.csv')
    res = train.values.tolist()
    for i in range(len(res)):
        res[i].pop(0)
    return res

def get_answers():
    survival = pd.read_csv("survivaldata.csv")

    answers = survival["Survived"].values.tolist()

    return answers

def write_performance(performance):
    df = pd.DataFrame({"Epoch":list(map(lambda x: x+1, range(len(performance)))), "Performance":performance})
    df.to_excel("performance.xlsx")
