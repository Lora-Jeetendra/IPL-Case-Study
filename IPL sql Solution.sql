-- Q1 what are the top 5 players with most player of the match awards? 
select player_of_match, count(*) as count_ from matches
GROUP BY player_of_match
order by count_ desc
limit 5;

-- Q2 HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?
select season, winner,count(*)as count_winner from matches
GROUP BY season, winner
order by season, count_winner desc;

-- Q3 WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?
select avg(strike_rate) from
(select batsman, round((count(ball)/sum(total_runs))*100,2) as strike_rate from deliveries
GROUP BY batsman )as stats ;

-- Q4 WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING
-- SECOND?
select winner,count(*) as winner_count from matches
where win_by_runs >0 
group by winner
order by winner_count desc;

-- Q5 WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?
select batsman, sum(batsman_runs),(sum(batsman_runs)/count(ball))*100 as strike_rate from deliveries
GROUP BY batsman 
HAVING sum(batsman_runs)> 200
order by strike_rate desc
limit 2;

-- Q6 HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?
select batsman, count(*) as dismissal_count from deliveries
where player_dismissed is not null and bowler='SL Malinga'
group by batsman
order by dismissal_count desc;

-- Q7 WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES
-- COMBINED) HIT BY EACH BATSMAN?
select batsman, avg(case when batsman_runs=4 or batsman_runs=6
then 1 else 0 end)*100 as avg_boundaries
from deliveries group by batsman;

-- Q8 WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
select season, batting_team,avg(fours + sixes) as avg_boundaries from 
(SELECT season, match_id,batting_team,
sum(case when batsman_runs=4 then 1 else 0 end) as fours,
sum(case when batsman_runs =6 then 1 else 0 end) as sixes
from deliveries, matches
where deliveries.match_id=matches.id
group by season,match_id,batting_team) as batting_status
group by season,batting_team;

-- Q9 WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?
 select season,batting_team, max(total_runs) as highest_partnership from
 (select season,batting_team,partnership,sum(total_runs) as total_runs from 
 (select season,match_id,batting_team,over_no,
  sum(batsman_runs) as partnership, sum(batsman_runs)
  + sum(extra_runs) as total_runs from deliveries,
  matches where deliveries.match_id=matches.id
  GROUP BY season,match_id,batting_team,over_no) as team_score
  group by season,batting_team,partnership) as highest_partnership
  group by season,batting_team;
  
  -- Q10 HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?
  select match_id, bowling_team, sum(wide_extra + noball_extra) as extras from
  (select match_id,bowling_team,
  sum(case when wide_runs >0 then 1 else 0 end) as wide_extra,
  sum(case when noball_runs >0 then 1 else 0 end) as noball_extra
  from deliveries
  GROUP BY match_id, bowling_team) as extra_runs
  group by match_id, bowling_team;
  
-- Q11 WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE
-- MATCH?
select match_id, bowler, count(*) as wickets_taken from deliveries
where player_dismissed is not null
group by match_id,bowler 
order by count(*) desc
limit 1;

-- Q12 HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
select winner, city, count(*) AS matches_won from matches
where result='normal'
group by winner,city
order by matches_won desc;

-- Q13 HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?
select season,toss_winner, count(*) as toss_win_count
from matches 
GROUP BY season,toss_winner
order by season,toss_win_count desc;

-- Q14 HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?
select season,player_of_match, count(*) as count from matches
where player_of_match is not null
group by season, player_of_match
order by season,COUNT desc;

-- Q 15 WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN
-- EACH MATCH?
select match_id ,inning, avg(total_runs) from
(select match_id, inning,over_no,sum(total_runs) as total_runs from deliveries
group by match_id,inning,over_no) as inning_stats
group by match_id,inning;
-- select match_id, inning, sum(total_runs) from deliveries
-- group by match_id, inning;

-- Q16 WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH? 
-- select matches.season,match_id,batting_team,max(total_score) from
(select matches.season,match_id, inning,batting_team, sum(total_runs) as total_score from deliveries,matches
where matches.id=deliveries.match_id
group by matches.season,match_id, inning,batting_team)
order by total_score desc
limit 1;

-- Q 17 WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
select matches.season,match_id,inning,batsman,sum(batsman_runs) as runs from deliveries,matches
where matches.id=deliveries.match_id
GROUP BY season,match_id,inning,batsman
order by runs desc
limit 1 ;
select * from matches where id=60;
