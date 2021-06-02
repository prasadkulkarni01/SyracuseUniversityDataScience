import math

def get_distance(x1, y1, x2, y2):
    """ get two-dimensional Euclidean distance """
    return math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)

def get_average_distance_to_opponents(obs, player_x, player_y):
    """ get average distance to closest opponents """
    distances_sum = 0
    distances_amount = 0
    for i in range(1, len(obs["right_team"])):
        # if opponent is ahead of player
        if obs["right_team"][i][0] > (player_x - 0.02):
            distance_to_opponent = get_distance(player_x, player_y, obs["right_team"][i][0], obs["right_team"][i][1])
            if distance_to_opponent < 0.03:
                distances_sum += distance_to_opponent
                distances_amount += 1
    # if there is no opponents close around
    if distances_amount == 0:
        return 2, distances_amount
    return distances_sum / distances_amount, distances_amount

from kaggle_environments.envs.football.helpers import *

def offence_actions(obs, player_x, player_y):
    # Away from goal shot
    if player_x < -0.6 or obs["ball_owned_player"] == 0:
        if Action.Sprint in obs["sticky_actions"]:
            return Action.ReleaseSprint
        return Action.Shot
    
    # Highpass
    if player_x < -0.3 or obs["ball_owned_player"] == 0:
        if Action.Right not in obs["sticky_actions"]:
            return Action.Right
        if Action.Sprint in obs["sticky_actions"]:
            return Action.ReleaseSprint
        return Action.HighPass
    
    # Wrong angle pass
    if ((abs(player_y) > 0.15 and player_x > 0.85) or
                (player_x > 0.7 and player_y > 0.07 and obs["left_team_direction"][obs["active"]][1] > 0) or
                (player_x > 0.7 and player_y < -0.07 and obs["left_team_direction"][obs["active"]][1] < 0)):
        
        if player_y > 0:
            if Action.Top not in obs["sticky_actions"]:
                return Action.Top
        else:
            if Action.Bottom not in obs["sticky_actions"]:
                return Action.Bottom
        if Action.Sprint in obs["sticky_actions"]:
            return Action.ReleaseSprint
        return Action.ShortPass
    

    # Close to goal keeper shot
    opponent_goalkeeper = [
        obs["right_team"][0][0] + obs["right_team_direction"][0][0] * 10,
        obs["right_team"][0][1] + obs["right_team_direction"][0][1] * 10
    ]
    if (obs["ball_owned_player"] == obs["active"] and obs["ball_owned_team"] == 0 and
        get_distance(player_x, player_y, opponent_goalkeeper[0], opponent_goalkeeper[1]) < 0.3):
        return Action.Shot
    
    # shortpass
    for i in range(1, len(obs["right_team"])):
            distance_to_opponent = get_distance(player_x, player_y, obs["right_team"][i][0], obs["right_team"][i][1])
            if distance_to_opponent < 0.03:
                for j in range(1, len(obs["left_team"])):
                    distance_to_teammate = get_distance(player_x, player_y, obs["left_team"][j][0], obs["left_team"][j][1])
                    if distance_to_teammate < 0.2:
                        teammate_distance_to_goal = get_distance(obs["left_team"][j][0], obs["left_team"][j][1], 1, 0)
                        player_distance_to_goal = get_distance(player_x, player_y, 1, 0)
                        if teammate_distance_to_goal < player_distance_to_goal:
                            
                            if Action.Sprint in obs["sticky_actions"]:
                                return Action.ReleaseSprint
                            return Action.ShortPass
    
    # dodge Opponent
    biggest_distance, final_opponents_amount = get_average_distance_to_opponents(obs, player_x + 0.01, player_y)
    top_right, opponents_amount = get_average_distance_to_opponents(obs, player_x + 0.01, player_y - 0.01)
    if (top_right > biggest_distance and player_y > -0.15) or (top_right == 2 and player_y > 0.07):
            biggest_distance = top_right
            final_opponents_amount = opponents_amount
            if Action.Sprint not in obs["sticky_actions"]:
                return Action.Sprint
            return Action.TopRight
    bottom_right, opponents_amount = get_average_distance_to_opponents(obs, player_x + 0.01, player_y + 0.01)
    if (bottom_right > biggest_distance and player_y < 0.15) or (bottom_right == 2 and player_y < -0.07):
            biggest_distance = bottom_right
            final_opponents_amount = opponents_amount
            if Action.Sprint not in obs["sticky_actions"]:
                return Action.Sprint
            return Action.BottomRight
    if final_opponents_amount >= 3:
        if Action.Sprint not in obs["sticky_actions"]:
            return Action.Sprint
        return Action.HighPass
    
    # Idle 
    return Action.Idle    

def defence_actions(obs, player_x, player_y):
    
    # Run right
    if (obs["ball"][0] > player_x and
                abs(obs["ball"][1] - player_y) < 0.01):
        return Action.Right
    
    # Run left
    if (obs["ball"][0] < player_x and
                abs(obs["ball"][1] - player_y) < 0.01):
        return Action.Left
    
    # Run to Bottom
    if (obs["ball"][1] > player_y and
                abs(obs["ball"][0] - player_x) < 0.01):
        return Action.Bottom
    
    # Run to top
    if (obs["ball"][1] < player_y and
                abs(obs["ball"][0] - player_x) < 0.01):
        return Action.Top
    
    # Run to top right
    if (obs["ball"][0] > player_x and
                obs["ball"][1] < player_y):
        return Action.TopRight
    
    # Run to top left
    if (obs["ball"][0] < player_x and
                obs["ball"][1] < player_y):
        return Action.TopLeft
    
    # Run to bottom right
    if (obs["ball"][0] > player_x and
                obs["ball"][1] > player_y):
        return Action.BottomRight
    
    # Run to bottom left
    if (obs["ball"][0] < player_x and
                obs["ball"][1] > player_y):
        return Action.BottomLeft
    
    # Idle
    return Action.Idle

def goalkeeper_actions(obs, player_x, player_y):
    
    # Shot away from goal
    if player_x < -0.6 or obs["ball_owned_player"] == 0:
        if Action.Sprint in obs["sticky_actions"]:
            return Action.ReleaseSprint
        return Action.Shot
    
    # Idle
    return Action.Idle
    

def special_actions(obs, player_x, player_y):
    
    # Corner shot
    if obs['game_mode'] == GameMode.Corner:
        if player_y > 0:
            if Action.TopRight not in obs["sticky_actions"]:
                return Action.TopRight
        else:
            if Action.BottomRight not in obs["sticky_actions"]:
                return Action.BottomRight
        return Action.Shot
    
    # Free kick
    if obs['game_mode'] == GameMode.FreeKick:
        if player_x > 0.5:
            if player_y > 0:
                if Action.TopRight not in obs["sticky_actions"]:
                    return Action.TopRight
            else:
                if Action.BottomRight not in obs["sticky_actions"]:
                    return Action.BottomRight
            return Action.Shot
        # high pass if player far from goal
        else:
            if Action.Right not in obs["sticky_actions"]:
                return Action.Right
            return Action.HighPass
        
    # Penalty
    if obs['game_mode'] == GameMode.Penalty:
        return Action.Shot
    
    # Goal kick
    if obs['game_mode'] == GameMode.GoalKick:
        return Action.ShortPass
    
    # Kick off
    if obs['game_mode'] == GameMode.KickOff:
        return Action.ShortPass
    
    # throw in
    if obs['game_mode'] == GameMode.ThrowIn:
        return Action.ShortPass
    
    # Idle 
    return Action.Idle 
    
    
    

def get_action(obs, player_x, player_y):
    """ get action of appropriate pattern in agent's memory """
    # team player have the ball
    if obs["ball_owned_player"] == obs["active"] and obs["ball_owned_team"] == 0:
        return offence_actions(obs, player_x, player_y)
    # team player dont have the ball
    if obs["ball_owned_team"] != 0:
        return defence_actions(obs, player_x, player_y)
    # team goalkeeper has the ball
    if (obs["ball_owned_player"] == obs["active"] and
                obs["ball_owned_team"] == 0 and
                obs["ball_owned_player"] == 0):
        return goalkeeper_actions(obs, player_x, player_y)
    # Game is not in normal session
    if obs['game_mode'] != GameMode.Normal:
        return special_actions(obs, player_x, player_y)
    
    return Action.Idle
  

# @human_readable_agent wrapper modifies raw observations 
# provided by the environment:
# https://github.com/google-research/football/blob/master/gfootball/doc/observation.md#raw-observations
# into a form easier to work with by humans.
# Following modifications are applied:
# - Action, PlayerRole and GameMode enums are introduced.
# - 'sticky_actions' are turned into a set of active actions (Action enum)
#    see usage example below.
# - 'game_mode' is turned into GameMode enum.
# - 'designated' field is removed, as it always equals to 'active'
#    when a single player is controlled on the team.
# - 'left_team_roles'/'right_team_roles' are turned into PlayerRole enums.
# - Action enum is to be returned by the agent function.
@human_readable_agent
def agent(obs):
  # Global param
  goal_threshold = 0.5
  gravity = 0.098
  pick_height = 0.5
  step_length = 0.015 # As we always sprint
  body_radius = 0.012
  slide_threshold = step_length + body_radius
  # dictionary for player action data
  obs["player_action"] = {}
  # coordinates of the ball in the next step
  obs["player_action"]["ball_next_coords"] = {
      "x": obs["ball"][0] + obs["ball_direction"][0] * 2,
      "y": obs["ball"][1] + obs["ball_direction"][1] * 2
  }
  # Make sure player is running.
  if Action.Sprint not in obs["sticky_actions"]:
      return Action.Sprint
  # We always control left team (observations and actions
  # are mirrored appropriately by the environment).
  controlled_player_pos = obs["left_team"][obs["active"]]
  # get action of appropriate pattern in agent's memory
  action = get_action(obs, controlled_player_pos[0], controlled_player_pos[1])
  # return action
  return action