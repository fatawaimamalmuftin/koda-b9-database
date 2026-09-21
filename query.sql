-- 1 login
SELECT 
id_users, full_name, email, password, bio, location, profile
FROM users 
WHERE email = $1;


-- 2 register
INSERT INTO users (
    full_name, email, password, bio, location, profile, agree
)


-- 3 get event list with search n filter
SELECT 
co.id_community, co.title, co.images, co.description
FROM community co
LEFT JOIN community_categories cc
ON co.id_community = cc.community_id
LEFT JOIN categories c
ON cc.category_id = c.id_categories
WHERE $1 = '' 
OR co.title ILIKE %$1%
OR c.name_categories ILIKE %$1%;


-- 4 get detail
SELECT 
e.id_event, e.title, e.images, e.date, e.start_time, e.end_time, e.location, e.attendees, e.capacity, e.description, e.event_format, c.name_categories, co.id_community, co.title AS "community"
FROM events e
JOIN categories c
ON e.categories_id = c.id_categories
JOIN community co
ON e.community_id = co.id_community
WHERE e.id_event = $1;


-- 5 join/leave event
-- join
INSERT INTO event_members (users_id, event_id)
VALUES ($1, %2);
-- leave
DELETE FROM event_members
WHERE users_id = %1
AND event_id = $2;


-- 6 get upcoming event
SELECT 
e.id_event, e.title, e.images, e.date, e.start_time, e.end_time, e.location
FROM events e
WHERE e.date >= CURRENT_DATE
ORDER BY e.date ASC, e.start_time ASC;


-- 7 get my event
SELECT 
e.id_event, e.title, e.images, e.date, e.start_time, e.end_time, e.location, e.attendees, e.capacity
FROM cart c
JOIN events e
ON c.events_id = e.id_event
WHERE c.users_id = $1
ORDER BY e.date ASC;


-- 8 get community list with search n filter
SELECT 
co.id_community, co.title, co.images AS "image",
co.description, ARRAY_AGG(c.name_categories) AS "categories",
co.members, co.upcoming
FROM community co
JOIN community_categories cc
ON co.id_community = cc.community_id
JOIN categories c
ON cc.category_id = c.id_categories
WHERE co.title ILIKE %$1%
OR c.name_categories ILIKE %$1%
GROUP BY co.id_community, co.title, co.images, co.description, co.members, co.upcoming
ORDER BY co.title ASC;


-- 9 get community detail
SELECT 
co.id_community, co.title, co.images, co.description, co.members, co.upcoming, u.id_users AS "creator_id", u.full_name AS "creator_name"
FROM community co
JOIN users u
ON co.users_id = u.id_users
WHERE co.id_community = $1;


-- 10 get popular community
SELECT 
co.id_community, co.title, co.images, COUNT(cm.users_id) AS "total_members"
FROM community co
JOIN community_members cm
ON co.id_community = cm.community_id
GROUP BY co.id_community, co.title, co.images
ORDER BY total_members DESC
LIMIT 3;


-- 11 Join / Leave Community
-- join
INSERT INTO community_members (
    community_id,
    users_id
)
VALUES ($1, $2);
-- leave
DELETE FROM community_members
WHERE community_id = $1
AND users_id = $2;


-- 12 Get Community Member
SELECT 
u.id_users, u.full_name, u.profile, cm.joined_at
FROM community_members cm
JOIN users u
ON cm.users_id = u.id_users
WHERE cm.community_id = $1
ORDER BY cm.joined_at ASC;


-- 13 Get User Profile
SELECT profile AS "profile user",
FROM users
WHERE id_users = $1;


-- 14 Change User Profile
UPDATE users
SET password = $1
WHERE id_users = $2


-- 15 Change Password
UPDATE users
SET password = $1
WHERE id_users = $2


-- 16 Get / Set Testimony
-- get
SELECT 
id_testimonial, text, name, job, profile, users_id
FROM testimonials
ORDER BY id_testimonial DESC;
-- set
INSERT INTO testimonials ( text, name, job, profile, users_id )
VALUES ( $1, $2, $3, $4, $5)


-- 17 Get My Notification
SELECT 
id_notification, title, description, time, type, unread
FROM notifications
WHERE users_id = $1
ORDER BY time DESC;


-- 18 Get Organizer Dashboard & Information
SELECT 
COUNT(e.id_event) AS "Total Events", 
SUM(e.attendees) AS "Total Attendees", 
ROUND(SUM(e.attendees) * 100 / SUM(e.capacity) ) AS "Avg Fill Rate",
SUM(e.views) AS "Event Views"
FROM community co
JOIN events e
ON co.id_community = e.community_id
WHERE co.creator_id = $1;


-- 19 Create / Edit Event
-- create
INSERT INTO events ( 
    title, images, date, start_time, end_time, location, capacity, description, event_format, categories_id, community_id
)
-- edit
UPDATE events e
SET title = $1, images = $2, date = $3, start_time = $4, end_time = $5, location = $6, capacity = $7, description = $8, event_format = $9, categories_id = $10


-- 20 Get Admin Dashboard & Information
SELECT COUNT(*) AS "TOTAL USERS"
FROM users;

SELECT COUNT(*) AS "TOTAL EVENTS"
FROM events;

SELECT COUNT(*) AS "TOTAL COMMUNITES"
FROM community;

SELECT
    ROUND(
        SUM(attendees) * 100 / SUM(capacity)
    ) AS "AVG FILL RATE"
FROM events;