#include <iostream>
#include <set>

#include <soci/soci.h>
#include <soci/sqlite3/soci-sqlite3.h>
#include <nlohmann/json.hpp>
#include "foo.h"
using json = nlohmann::json;


//std::string addReaction(soci::session& dbSession, const std::string& responder, const std::string& target, const std::vector<std::string>& reactions) {
//
//    std::string currentData;
//    dbSession << "select reactions from messages where id = :id;", soci::use(target), soci::into(currentData);
//    if (currentData.empty()) {
//        currentData = "{}";
//    }
//
//    auto jsonData = json::object();
//    try {
//        jsonData = json::parse(currentData);
//    } catch (const json::parse_error& e) {
//        int y = 00;
//    }
////    for (const auto& reaction : reactions) {
////        auto it = jsonData.find(reaction);
////        if (it == jsonData.end()) {
////            jsonData[reaction] = json::array({responder});
////        } else {
////            std::set<std::string> users = jsonData[reaction];
////            users.insert(responder);
////            it.value() = users;
////        }
////    }
//
//    // remove responder from each reaction currently stored
//    // if there are no responders left for reaction - remove reaction
//    for (auto it = jsonData.begin(); it != jsonData.end(); ) {
//        std::set<std::string> users = it.value();
//        users.erase(responder);
//        if (users.empty()) {
//            it = jsonData.erase(it);
//        } else {
//            it.value() = users;
//            ++it;
//        }
//    }
//
//    // add last reaction to the data
//    if (!reactions.empty()) {
//        const auto reaction = reactions.back();
//        const auto it = jsonData.find(reaction);
//        if (it == jsonData.end()) { // no reaction found, add it
//            jsonData[reaction] = json::array({responder});
//        } else { // reaction found, add responder to array
//            std::set<std::string> users = jsonData[reaction];
//            users.insert(responder);
//            it.value() = users;
//        }
//    }
//
//    currentData = jsonData.dump();
//
//    dbSession << "update messages"
//           " set reactions = :reactions"
//           " where id = :id",
//           soci::use(currentData), soci::use(target);
//
//    return currentData;
//}

std::vector<std::string> addReaction(soci::session& dbSession, const std::string& responder, const std::string& target, const std::vector<std::string>& reactions) {

    std::string currentData;
    dbSession << "select reactions from messages where id = :id;", soci::use(target), soci::into(currentData);
    if (currentData.empty()) {
        currentData = "{}";
    }

    auto jsonData = json::object();
    try {
        jsonData = json::parse(currentData);
    } catch (const json::parse_error& e) {
        int y = 00;
    }

    const std::string userId = responder;
//    for (const auto& reaction : reactions) {
//        auto it = jsonData.find(reaction);
//        if (it == jsonData.end()) {
//            jsonData[reaction] = json::array({responder});
//        } else {
//            std::set<std::string> users = jsonData[reaction];
//            users.insert(responder);
//            it.value() = users;
//        }
//    }
    if (reactions.size()) {
        jsonData[userId] = reactions;
    } else {
        jsonData.erase(userId);
    }

    currentData = jsonData.dump();

    dbSession << "update messages"
                 " set reactions = :reactions"
                 " where id = :id;",
            soci::use(currentData), soci::use(target);

//    auto reactionUsers = json::object();
//    for (const auto& item: jsonData.items()) {
//        const std::string& user = item.key();
//        for (const std::string& reaction : item.value()) {
//            auto it = reactionUsers.find(reaction);
//            if (it == reactionUsers.end()) {
//                reactionUsers[reaction] = json::array({user});
//            } else {
//                std::set<std::string> users = reactionUsers[reaction];
//                users.insert(user);
//                it.value() = users;
//            }
//        }
//    }

//    std::cout << "***************************\n";

    std::unordered_map<std::string, std::set<std::string>> reactionUsers;
    for (const auto& item: jsonData.items()) {
//        std::cout << item << "\n";
        const std::string& user = item.key();
        for (const std::string& reaction : item.value()) {
            auto it = reactionUsers.find(reaction);
            if (it == reactionUsers.end()) {
                reactionUsers[reaction] = std::set<std::string>({user});
            } else {
//                std::set<std::string> users = reactionUsers[reaction];
                reactionUsers[reaction].insert(user);
//                it.value() = users;
            }
        }

//        std::cout <<
    }

//
    std::vector<std::string> response;
    response.reserve(reactionUsers.size());
    for (const auto& ru : reactionUsers) {
        auto reaction = json::object();
        reaction[ru.first] = ru.second;
        response.push_back(reaction.dump());
//        std::cout << reaction.dump() << "\n";
    }

    return response;//json::object({response}).dump();
}

using reaction_users_t = std::unordered_map<std::string, std::set<std::string>>;
using user_reactions_t = std::unordered_map<std::string, std::vector<std::string>>;


void printResults(std::vector<std::string> results) {
    std::cout << "***************************\n";

    for (const auto& it : results) {
        std::cout << it << " ";
    }
    std::cout << "\n";
}

class ReactionsView {
public:
    ReactionsView() =delete;

    ReactionsView(std::string currentData) {
        populate(currentData);
    }

//    ReactionsView(const ReactionsView&) = default;
//    ReactionsView& operator=(const ReactionsView&) =default;

    ~ReactionsView() =default;

    // returns map of all reactions and their belonging users. one reaction can have multiple unique users
    const reaction_users_t& reactions() {
        return mReactionUsers;
    }

    // returns map of all users and their belonging reactions. one user can have multiple reactions of same value
    const user_reactions_t& users() {
        return mUserReactions;
    }

    // returns last reaction of given user. throws std::out_of_range if user not found
    const std::string& UserLastReaction(const std::string& user) const {
        return mUserReactions.at(user).back();
    }

private:

    void populate(std::string currentData) {
        auto jsonData = json::object();
        try {
            jsonData = json::parse(currentData);
        } catch (const json::parse_error& e) {
            // DebugLog
        }

        for (auto it = jsonData.begin(); it != jsonData.end(); ++it) {
            const auto& user = it.key();
            mUserReactions[it.key()] = std::vector<std::string>(it.value());
            for (const auto& reaction : it.value()) {
                if (mReactionUsers.end() == mReactionUsers.find(reaction)) {
                    mReactionUsers[reaction] = std::set<std::string>({user});
                } else {
                    mReactionUsers[reaction].insert(user);
                }
            }
        }
    }

    reaction_users_t mReactionUsers;
    user_reactions_t mUserReactions;
//    std::unordered_map<std::string, std::string> mUserLastReactions;
};



int main(int argc, char** argv) {
    foo();
//    auto j3 = json::parse(R"({"happy": true, "pi": 3.141})");

//    const std::string dbPath{1 < argc ? argv[0] : "/Volumes/REPOS/repos/mydb.db"};
//    soci::session dbSession(soci::sqlite3, dbPath);
//
////    std::string currentReactions;
////    dbSession << "select reactions from messages where id = 1", soci::into(currentReactions);
////    std::cout << "reactions: '" << currentReactions << "'\n";
////
////    int count;
////    dbSession << "select count(*) from messages", soci::into(count);
////    std::cout << "rows: " << count << "\n";
//
//    printResults(addReaction(dbSession, "nikola", "1", {"R1", "R2"}));
//    printResults(addReaction(dbSession, "beba", "1", {"R1"}));
//    printResults(addReaction(dbSession, "nikola", "1", {"R3"}));
////    std::cout << addReaction(dbSession, "nikola", "1", {"R1"}) << "\n";
//    printResults(addReaction(dbSession, "beba", "1", {"R1", "R3"}));
//    printResults(addReaction(dbSession, "beba", "1", {}));


    int y = 99;
    return 0;
}

int foo() {
    return 2;
}