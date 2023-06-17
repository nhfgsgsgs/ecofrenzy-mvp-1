import os
import guidance
from langchain.chat_models import ChatOpenAI
from langchain.chains import create_extraction_chain
import time

guidance.llm = guidance.llms.OpenAI("gpt-3.5-turbo-16k")

llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")

schema_challenge = {
    "type": "object",
    "properties": {
        "name": {"type": "string"},
        "category": {
            "type": "string",
            "enum": [
                "Energy & Resources",
                "Transportation",
                "Consumption",
                "Waste Management",
                "Forestry",
                "Awareness & Innovation",
            ],
        },
        "description": {"type": "string"},
        "impact": {"type": "string"},
        "level": {"type": "string", "enum": ["Easy", "Intermediate", "Hard"]},
        "creativity": {"type": "string", "enum": ["Direct", "Indirect"]},
        "verification": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "question": {"type": "string"},
                    "answer": {"type": "string"},
                },
                "required": ["question", "answer"],
            },
        },
    },
    "required": [
        "name",
        "category",
        "description",
        "impact",
        "level",
        "creativity",
        "verification",
    ],
}


transform_challenge = create_extraction_chain(
    schema_challenge,
    llm,
)

challenge_generation_program = guidance(
    """{{#system~}}
You are my AI user analyzing system for my social media app that promotes sustainability through daily fun and engaging challenges.
Your role is to analyze the user’s profile and previous interactions with daily challenges in the app, to generate insights about the user's preferences and behavior.
Then from these understandings, you develop a growth plan for the user to help them to live a more sustainable lifestyle.
{{~/system}}
{{#user~}}
You are analyzing the following user:
- Age: {{user_data.age}}
- Gender: {{user_data.gender}}
- Location: {{user_data.location}}
- Has used the app for {{user_data.usageDay}} days

Here is the list of past user's interactions with daily challenges in most recent days:
{{#each records}}
The user has received the following 3 challenges in usage day {{@index + user_data.usageDay}}:
- Challenge 1: {{this.given_missions[0]['name']}}, {{this.given_missions[0]['category']}}, {{this.given_missions[0]['description']}}, {{this.given_missions[0]['level']}}, impact is {{this.given_missions[0]['creativity']}}
- Challenge 2: {{this.given_missions[1]['name']}}, {{this.given_missions[1]['category']}}, {{this.given_missions[1]['description']}}, {{this.given_missions[1]['level']}}, impact is {{this.given_missions[1]['creativity']}}
- Challenge 3: {{this.given_missions[2]['name']}}, {{this.given_missions[2]['category']}}, {{this.given_missions[2]['description']}}, {{this.given_missions[2]['level']}}, impact is {{this.given_missions[2]['creativity']}}
{{#if this.is_picked~}}
The user has chosen the to complete challenge {{this.mission_picked}} today. 
{{~#if this.is_completed~}}
The user has completed the chosen challenge today.
{{~else~}}
The user has not completed the chosen challenge today.
{{~/if}}
{{~else~}}
The user has not chosen any challenge today.
{{~/if}}
{{/each}}

Based on observations from:
- User's profile
- Which challenge is chosen and not chosen? (Analyze every attribute of that challenge)
- Is the challenge chosen completed?
Derive analysis of the user's preferences and behavior by answering the following questions:
- Which patterns or trends can you identify from the user's completed and declined challenges?
- Which kinds of challenge does the user seem to be most interested in? Hypothesize why.
- Which kinds of challenge does the user seem to avoid? Hypothesize why.
- Based on the user's profile and demonstrated behavior, what might be the user's motivations or barriers in their sustainability journey?
{{~/user}}
{{#assistant~}}
{{gen 'analysis_on_behavior' n=1 temperature=1}}
{{~/assistant}}

{{#block hidden=True}}
{{#user~}}
Based on this analysis on the user's behavior:
{{analysis_on_behavior}}

You list out key insights about the user's preferences and behavior (3 insights) in bullet points. The output must have the format as the given bellow example:
[
    "bullet point 0",
    "bullet point 1",
    "bullet point 2"
]

{{~/user}}
{{#assistant~}}
{{gen 'preferences' n=1 temperature=1}}
{{~/assistant}}
{{/block}}

{{#user~}}
Based on the analysis, you develop the growth plan for the user to help them to live a more sustainable lifestyle:
- What is the user's current sustainability level?
- Which categories should be focused on to encourage the user's engagement and progression in their sustainability journey?
- What new challenges can be introduced to help the user to step out of their comfort zone while still aligning with their interests?
{{~/user}}

{{#assistant~}}
{{gen 'analysis_growth_plan' n=1 temperature=1}}
{{~/assistant}}

{{#block hidden=True}}
{{#user~}}
Based on this growth plan you develop for the user:
{{analysis_growth_plan}}

You summarize the general growth plan for the user (3 bullet points, each start with a verb. The output must have the format as the given bellow example:
[
    "bullet point 0",
    "bullet point 1",
    "bullet point 2"
]
{{~/user}}
{{#assistant~}}
{{gen 'growth_plan' n=1 temperature=0}}
{{~/assistant}}
{{/block}}

{{#user~}}
Based on the analysis on the user's behavior and the growth plan, you develop challenges for the user to complete in the next day.
A challenge should have the following attributes:
- Name: The name of the challenge (For example: “Bring Your Own Bag”)
- Category: One of [Energy & Resources, Transportation, Consumption, Waste Management, Forestry, Awareness & Innovation]
- Descriptions: The specific descriptions and guidelines to complete the challenge (For example: “To reduce the use & impact of plastic bags, you should buy a tote bag, fabric bag or any bag that makes you comfortable to carry things around. Then, take a picture of you with the bag to share the moment with everyone!”)
- Impact: The impact of doing the challenge (For example: "Reduce plastic waste")
- Level: Determined by whether the challenges take that many activities to complete, can be [Easy, Intermediate, Hard]
- Creativity: Determined by whether the challenge shown describes direct relation to sustainability or indirect, can be [Direct, Indirect] (indirect means the activity doesn’t sound related to sustainability but actually contributes to sustainability). For example: “Bring Your Own Bag” - Direct Relation to Sustainability, “Go Grocery Shopping for 05 Days Use” - Indirect Relation to Sustainability)
- Verification: The verification yes/no questions for the image verification system is to verify whether the picture the user takes is aligned with the challenge, and the Desired answer is the true answer for the question. (For example: “Does this picture show a person with a bag that is not plastic?” desired answer: yes)

You must return 3 challenges, each challenge has the following json format (no words needed outside the blankets):
{
    "name": Name,
    "category": Category,
    "description": Descriptions,
    "impact": Impact 11,
    "level": Level,
    "creativity": Creativity,
    "verification": [list of dictionaries, each dictionary has the following format: {"question": Question, "desired_answer": Desired answer}]
}
{{~/user}}

{{#assistant~}}
{{gen 'challenge' temperature=1}}
{{~/assistant}}
"""
)


def str2lst(str):
    # find all the indices of the double quotes
    quotes_indices = [i for i, ltr in enumerate(str) if ltr == '"']
    assert (
        len(quotes_indices) == 6
    ), "The number of double quotes in the string is not equal to 6!"
    # extract the strings between the double quotes
    sentences = [
        str[quotes_indices[i] + 1 : quotes_indices[i + 1]]
        for i in range(0, len(quotes_indices), 2)
    ]
    return sentences


def lambda_handler(event, context):
    print(event)
    return

    consecutive_errors = 0
    while True:
        try:
            output = challenge_generation_program(
                user_data=event["user_data"], records=event["records"]
            )
            break
        except Exception as e:
            if str(e) == "Too many (more than 5) OpenAI API RateLimitError's in a row!":
                consecutive_errors += 1
                if consecutive_errors > 5:
                    raise Exception("Too many consecutive errors!")
                else:
                    print("OpenAI API RateLimitError, retrying...")
                    time.sleep(60)
            else:
                raise Exception("Other error")

    challenge_str = output["challenge"]

    preferences = output["preferences"]
    print("Preferences:")
    print(preferences)
    print("\n")

    preferences = str2lst(preferences)

    growth_plan = output["growth_plan"]
    print("Growth plan:")
    print(growth_plan)
    print("\n")

    growth_plan = str2lst(growth_plan)

    challenges = transform_challenge.run(challenge_str)

    user_data = event["user_data"]
    user_data["preferences"] = preferences
    user_data["growth_plan"] = growth_plan

    return challenges, user_data
