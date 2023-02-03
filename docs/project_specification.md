**HARBOUR - Chat app**
=====================

By: Ethan Ciavolella, Shane Cleary, Evan Kaminsky, and Joseph Tommasi
Scrum Master: Eric Heitmann

Repository: https://github.com/Saltswimmer/ru-seniorproj

**Project Summary**
---------------

HARBOUR will be a general purpose instant messaging platform. The platform will employ a "hybrid social" approach, combining the exclusivity of group messaging services such as Discord with the outreach of platforms like Twitter.

**Project Goals**
-------------

This project hopes to:
1. Provide a user-friendly general purpose instant messaging platform.
2. Allow users to create private, secure group chats for friends and acquaintances.
3. Provide a way for groups to search for and join up with other groups with similar interests.

**Product Features**
----------------

1. **Availability** - The initial focus will be a web application
2. **Vessels (or servers)** - Group chats that can be divided into channels
3. **Boarding** - Allows for two servers to temporarily merge into one. Users of each server can chat with each other, and when they decide to end the temporary connection, the servers will separate.
4. **“Raising the flag”** - Allows vessels to be matched with other vessels of similar size and interests, so that they can board each other.
4. **Login** - Allow users to login using credentials setup with the app, or by using various OAuth services such as Google.
5. **Group messaging** - provide a way for users in a server to chat with each other. This is the primary way for members of a server to interact, and supports text and image messaging.
6. **Direct messaging** - allow individual users to directly message each other, separate from the main servers. This allows for private conversations to be held between users.
7. **Friends system** - Gives users the ability to add friends from a user list.
8. **User profile customization** - Users can choose their username and profile picture. Additionally, they can add a list of interests to support finding users or servers with similar interests. 

**Limitations**
-----------

1. **Security** - While security will be a priority for this project, we cannot guarantee the safety of users' personal information. New users will be presented with a license agreement that reflects this fact.
2. **Moderation** - Chat applications are notorious for having trouble keeping everything clean, this can be assisted with libraries and AI, but will never be 100%
3. **Scalability** - The application(s) will most likely not be able to be tested at scale, and as such may encounter eventual problems with the cost-efficient infrastructure employed

**Stretch Goals**
-------------

1. **Voice Chat** - VoIP support would be critical to the commercial success of this app, if it were to be made public. However for the purposes of this project it is not a top priority.
2. A friend suggestion feature that shows the user mutual friends  
3. Mobile applications (most likely android) - this is a big stretch since oftentimes you are developing for multiple platforms that require different codebases, however many users prefer the mobile experience for messaging.
4. Desktop application - this is a little less of a stretch than mobile, since it will require application programming, however the only difference between platforms will be deployment packages based on CPU architecture.
5. Fleet -  Two servers can also permanently join together in a fleet
6. Server customization - Users can customize the look and feel of their individual servers
7. Account linking - Ability to link accounts with other products (i.e. steam, github)
8. Roles - Server owner can promote users within a server to be administrators, or moderators, and possibly the ability to create a hierarchy of custom roles for a server. This will require a specific system to be upheld when server merge