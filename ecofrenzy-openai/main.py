import json
import random
from challenge_generation import lambda_handler as challenge_generation


def get_user(user_id: str):
    # Look for user's information in database db/user.json
    with open("db/user.json", "r") as f:
        users = json.load(f)
    user = next((user for user in users if user["_id"] == user_id), None)
    return user


def update_user(user_data: dict):
    with open("db/user.json", "r") as f:
        users = json.load(f)
    users = [user_data if user["_id"] == user_data["_id"] else user for user in users]

    with open("db/user.json", "w") as f:
        json.dump(users, f, indent=4)

    print("User updated")


def get_today_missions(user: dict):
    # Look for user's today missions in database db/mission.json
    if user["usageDay"] < 3:
        # If user is new, give them 3 missions
        with open("db/mission.json", "r") as f:
            missions = json.load(f)

        # Pick 3 missions randomly
        today_missions = random.sample(missions, 3)

    else:
        with open("db/history.json", "r") as f:
            history = json.load(f)

        user_history = history[0]["historyMission"]

        with open("db/user.json", "r") as f:
            users = json.load(f)

        user_data = users[0]
        user_data

        records = []
        for i in range(-3, 0):
            given_missions = [
                {
                    "name": mission["name"],
                    "category": mission["category"],
                    "description": mission["description"],
                    "level": mission["level"],
                    "creativity": mission["creativity"],
                }
                for mission in user_history[i]["givenMissions"]
            ]

            mission_picked_index = next(
                (
                    index
                    for (index, d) in enumerate(user_history[0]["givenMissions"])
                    if d["_id"] == user_history[0]["missionPicked"]
                ),
                None,
            )

            record = {
                "given_missions": given_missions,
                "is_picked": True,
                "mission_picked": mission_picked_index,
                "is_completed": True,
            }

            records.append(record)

        event = {"user_data": user_data, "records": records}

        # If user used the app for more than 3 days, give them personalized missions
        today_missions, user_data = challenge_generation(event, None)
        user['preferences'] = user_data['preferences']
        user['growth_plan'] = user_data['growth_plan']
        # add an _id field to each mission
        for mission in today_missions:
            mission["_id"] = mission["name"].replace(" ", "_")

    user["usageDay"] += 1
    update_user(user)

    return today_missions


def print_missions(missions: list):
    # Print missions with index
    for i, mission in enumerate(missions):
        print(f"{i+1}. {mission['name']}")
        print(f"Category: {mission['category']}")
        print(f"Description: {mission['description']}")
        print(f"Impact: {mission['impact']}")
        print("\n")


def update_user_history(user: dict, today_record: dict):
    with open("db/history.json", "r") as f:
        history = json.load(f)

        # Look for user's history in database db/history.json
        user_history = next(
            (
                user_history
                for user_history in history
                if user_history["user"] == user["_id"]
            ),
            None,
        )

        # If user's history is not found, create a new one
        if not user_history:
            user_history = {
                "user": user["_id"],
                "historyMission": [],
            }
            history.append(user_history)

        # Add today's record to user's history
        user_history["historyMission"].append(today_record)

        # Update the variable history
        history = [
            user_history if user_history["user"] == user["_id"] else user_history
            for user_history in history
        ]

    # Update the file db/history.json
    with open("db/history.json", "w") as f:
        json.dump(history, f, indent=4)


def program(user_id: str, reset: bool = False):
    # Get user's information in database db/user.json
    user = get_user(user_id)
    if not user:
        print("User not found")
        return
    else:
        print("User found")
        print(user)

    if reset:
        user["usageDay"] = 0
        update_user(user)

    while True:
        print(f"------DAY {user['usageDay'] + 1}------")

        today_missions = get_today_missions(user)
        print("Today missions:")
        print_missions(today_missions)

        idx = int(input("Choose a mission to complete today: "))
        chosen_mission = today_missions[idx - 1]

        complete_status = input("Day ended. Did you complete the mission? (y/n)")
        if complete_status == "y":
            is_completed = True
        else:
            is_completed = False

        # Update user's history of missions in db/history.json
        today_record = {
            "usageDay": user["usageDay"],
            "missionPicked": chosen_mission["_id"],
            "isCompleted": is_completed,
            "givenMissions": today_missions,
        }

        update_user_history(user, today_record)

        
        user = get_user(user_id)
        print(user)

        print("------")


if __name__ == "__main__":
    user_id = "test-person-1"
    program(user_id, reset=True)
