# API

Base url: https://9o3z9up7h8.execute-api.ap-southeast-1.amazonaws.com/prod/

1. Get today mission list

   - URL: /api/user/647f4871cba2f4670727a9a6/getToday
   - Method: GET

2. Get all mission list

   - URL: /api/mission
   - Method: GET

3. Update mission status

   - URL: /api/user/updateToday
   - Method: PUT
   - Body: { "missionId": "....", "userId": "647f4871cba2f4670727a9a6" }

4. Upload image

   - URL: /api/user/upload
   - Method: POST
   - Body: {
     file: "....",
     }

5. Create user
   - URL: /api/user
   - Method: POST
