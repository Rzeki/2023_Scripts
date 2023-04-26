# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.events import SlotSet
from rasa_sdk.executor import CollectingDispatcher
import pandas as pd
import datetime


class ActionGetUpcomingMatches(Action):

    def name(self) -> Text:
        return "action_get_upcoming_matches"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        date = datetime.datetime.now()

        df_matches = pd.read_csv(".\\actions\\Matches.csv", sep=";")
        column_names = list(df_matches.columns.values.tolist()[:4])
        column_names.append(df_matches.columns.values.tolist()[7])
        
        dispatcher.utter_message(text=("Sure, here is a list of all upcoming matches:"))
        dispatcher.utter_message(text="{: >20} {: >20} {: >20} {: >20} {: >20}".format(*column_names))
        for index, row in df_matches.iterrows():
            match_date = str(row['Date']).split(".")
            if datetime.datetime(int(match_date[2]),int(match_date[1]),int(match_date[0])) > date:
                dispatcher.utter_message(text=("{: <20} {: <20} {: <20} {: <20} {: <20}".format(str(row['ID']),str(row['Date']),str(row['Hour']),str(row['Team1']),str(row['Team2']))))
    

        return []
    
class ActionGetMatches(Action):

    def name(self) -> Text:
        return "action_get_past_matches"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        date = datetime.datetime.now()

        df_matches = pd.read_csv(".\\actions\\Matches.csv", sep=";")
        column_names_matches = list(df_matches.columns.values.tolist()[:4])
        column_names_matches.append(df_matches.columns.values.tolist()[7])
        column_names_matches.append(df_matches.columns.values.tolist()[11])
        
        dispatcher.utter_message(text=("Sure, here is a list of all past matches:"))
        dispatcher.utter_message(text="{: >20} {: >20} {: >20} {: >20} {: >20} {: >20}".format(*column_names_matches))
        for index, row in df_matches.iterrows():
            match_date = str(row['Date']).split(".")
            if datetime.datetime(int(match_date[2]),int(match_date[1]),int(match_date[0])) < date:
                dispatcher.utter_message(text=("{: <20} {: <20} {: <20} {: <20} {: <20} {: <20}".format(str(row['ID']),str(row['Date']),str(row['Hour']),str(row['Team1']),str(row['Team2']),str(row['Team_Victory']))))
    

        return []

class ActionGetPlayers(Action):

    def name(self) -> Text:
        return "action_get_players"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        df_players = pd.read_csv(".\\actions\\Players.csv", sep=";")
        
        column_names_players = list(df_players.columns.values.tolist())
        dispatcher.utter_message(text=("No problem, here's the list of all players in the tournament:"))
        dispatcher.utter_message(text=("{: <20} {: <20} {: <20} {: <20} {: <20} {: <20}".format(*column_names_players)))
        for index, row in df_players.iterrows():
            dispatcher.utter_message(text=("{: <20} {: <20} {: <20} {: <20} {: <20} {: <20}".format(*row)))
    

        return []