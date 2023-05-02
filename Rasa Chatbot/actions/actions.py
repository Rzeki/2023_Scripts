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
from csv import writer


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
        #time.sleep(1)
        dispatcher.utter_message(text="{: >20} {: >20} {: >20} {: >20} {: >20}".format(*column_names))
        #time.sleep(1)
        for index, row in df_matches.iterrows():
            match_date = str(row['Date']).split(".")
            if datetime.datetime(int(match_date[2]),int(match_date[1]),int(match_date[0])) > date:
                dispatcher.utter_message(text=("{: <10} {: <10} {: <10} {: <10} {: <10}".format(str(row['ID']),str(row['Date']),str(row['Hour']),str(row['Team1']),str(row['Team2']))))
                #time.sleep(1)

        return []
    
class ActionGetPastMatches(Action):

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
        #time.sleep(1)
        dispatcher.utter_message(text="{: >20} {: >20} {: >20} {: >20} {: >20} {: >20}".format(*column_names_matches))
        #time.sleep(1)
        for index, row in df_matches.iterrows():
            match_date = str(row['Date']).split(".")
            if datetime.datetime(int(match_date[2]),int(match_date[1]),int(match_date[0])) < date:
                dispatcher.utter_message(text=("{: <10} {: <10} {: <10} {: <10} {: <10} {: <10}".format(str(row['ID']),str(row['Date']),str(row['Hour']),str(row['Team1']),str(row['Team2']),str(row['Team_Victory']))))
                #time.sleep(1)
                
    

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
        #time.sleep(1)
        dispatcher.utter_message(text=("{: <10} {: <10} {: <10} {: <10} {: <10} {: <10}".format(*column_names_players)))
        #time.sleep(1)
        for index, row in df_players.iterrows():
            dispatcher.utter_message(text=("{: <10} {: <10} {: <10} {: <10} {: <10} {: <10}".format(*row)))
            #time.sleep(1)

        return []
    
class ActionAddPlayer(Action):

    def name(self) -> Text:
        return "action_add_player_to_file"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        df_players = pd.read_csv(".\\actions\\Players.csv", sep=";")
        
        player_ID = df_players['Player_ID'].tolist()
        player_ID = max([int(i) for i in player_ID]) + 1
        player_name = tracker.get_slot("player_add_name")
        player_team = tracker.get_slot("player_add_team")
        player_kills = tracker.get_slot("player_add_kills")
        player_deaths = tracker.get_slot("player_add_deaths")
        player_KD = player_kills if player_deaths=='0' else str(round((int(player_kills)/int(player_deaths)),2))
        
        with open('.\\actions\\Players.csv', 'a', newline="") as f_object:
            writer_object = writer(f_object, delimiter=';')
            writer_object.writerow([player_ID, player_name, player_team, player_kills, player_deaths, player_KD])
            f_object.close()
    

        return []
    
    class ResetSlot(Action):

        def name(self):
            return "action_reset_slots_add_player_form"

        def run(self, dispatcher, tracker, domain):
            return [SlotSet("player_add_name", None),SlotSet("player_add_team", None),SlotSet("player_add_kills", None),SlotSet("player_add_deaths", None)]
        
        
    class ResetSlot(Action):

        def name(self):
            return "action_reset_slots_info_player"

        def run(self, dispatcher, tracker, domain):
            return [SlotSet("player_ID_or_name", None)]
        
class ActionPlayerInfo(Action):

    def name(self) -> Text:
        return "action_find_info_player"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        df_players = pd.read_csv(".\\actions\\Players.csv", sep=";")
        
        player_ID_or_name = tracker.get_slot("player_ID_or_name")
        
        try:
            if player_ID_or_name.isnumeric():
                result = df_players.loc[df_players['Player_ID'] == int(player_ID_or_name)].values[0]
            else:
                result = df_players.loc[df_players['Player_name'] == str(player_ID_or_name)].values[0]
        except:
            dispatcher.utter_message(text=("I can't find player with that ID or nickname, please check if your information is correct."))
            return []
        column_names_players = list(df_players.columns.values.tolist())
        dispatcher.utter_message(text=("I've found this player, here's some information about him."))
        #time.sleep(1)
        dispatcher.utter_message(text=("{: <10} {: <10} {: <10} {: <10} {: <10} {: <10}".format(*column_names_players)))
        #time.sleep(1)
        dispatcher.utter_message(text=("{: <10} {: <10} {: <10} {: <10} {: <10} {: <10}".format(*result)))
        return []
    
class ResetMatchSlot(Action):

        def name(self):
            return "action_reset_slots_match_add_form"

        def run(self, dispatcher, tracker, domain):
            return [SlotSet("match_add_date", None), SlotSet("match_add_hour", None), SlotSet("match_add_team1", None), SlotSet("match_add_team2", None)]
        
class ResetMatchEditSlot(Action):

        def name(self):
            return "action_reset_slots_match_edit_form"

        def run(self, dispatcher, tracker, domain):
            return [SlotSet("match_edit_ID", None), SlotSet("match_edit_T1_N1", None), SlotSet("match_edit_T1_N2", None), SlotSet("match_edit_T1_N3", None), SlotSet("match_edit_T2_N1", None), SlotSet("match_edit_T2_N2", None), SlotSet("match_edit_T2_N3", None)]
        
class ActionAddMatch(Action):

    def name(self) -> Text:
        return "action_add_match_to_file"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        df_matches = pd.read_csv(".\\actions\\Matches.csv", sep=";")
        
        match_ID = df_matches['ID'].tolist()
        match_ID = max([int(i) for i in match_ID]) + 1
        match_date = tracker.get_slot("match_add_date")
        match_hour = tracker.get_slot("match_add_hour")
        match_team1 = tracker.get_slot("match_add_team1")
        match_team2 = tracker.get_slot("match_add_team2")
        
        
        
        with open('.\\actions\\Matches.csv', 'a', newline="") as f_object:
            writer_object = writer(f_object, delimiter=';')
            writer_object.writerow([match_ID, match_date, match_hour, match_team1, 'TBD', 'TBD', 'TBD', match_team2, 'TBD', 'TBD', 'TBD', 'TBD'])
            f_object.close()
    
        return []
    
class ActionEditMatch(Action):

    def name(self) -> Text:
        return "action_edit_match"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        df_matches = pd.read_csv(".\\actions\\Matches.csv", sep=";")
        
        match_edit_ID = tracker.get_slot("match_edit_ID")
        match_T1_N1 = tracker.get_slot("match_edit_T1_N1")
        match_T1_N2 = tracker.get_slot("match_edit_T1_N2")
        match_T1_N3 = tracker.get_slot("match_edit_T1_N3")
        match_T2_N1 = tracker.get_slot("match_edit_T2_N1")
        match_T2_N2 = tracker.get_slot("match_edit_T2_N2")
        match_T2_N3 = tracker.get_slot("match_edit_T2_N3")
        
        df_matches.loc[int(match_edit_ID)-1,'T1_Player1'] = str(match_T1_N1)
        df_matches.loc[int(match_edit_ID)-1,'T1_Player2'] = str(match_T1_N2)
        df_matches.loc[int(match_edit_ID)-1,'T1_Player3'] = str(match_T1_N3)
        df_matches.loc[int(match_edit_ID)-1,'T2_Player1'] = str(match_T2_N1)
        df_matches.loc[int(match_edit_ID)-1,'T2_Player2'] = str(match_T2_N2)
        df_matches.loc[int(match_edit_ID)-1,'T2_Player3'] = str(match_T2_N3)
        
        df_matches.to_csv(".\\actions\\Matches.csv", sep=";", index=False)
        
    
        return []
    