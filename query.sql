-- LOGIN
SELECT
    id_users,
    full_name,
    email,
    password
FROM users
WHERE email = $1;


-- REGISTER
INSERT INTO users (
    full_name,
    email,
    password
)
VALUES ($1, $2, $3)
RETURNING
    id_users,
    full_name,
    email;


-- CHECK EMAIL
SELECT
    id_users
FROM users
WHERE email = $1;


-- FORGOT PASSWORD & CREATE NEW PASSWORD
UPDATE users
SET
    password = $1,
    update_at = CURRENT_TIMESTAMP
WHERE email = $2;


-- GET EVENT LIST
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.description,
    e.event_format,
    e.community_id,
    c.title AS community_title
FROM events e
JOIN community c
    ON c.id_community = e.community_id
ORDER BY e.start_time ASC;


-- SEARCH EVENT
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.description,
    e.event_format,
    e.community_id,
    c.title AS community_title
FROM events e
JOIN community c
    ON c.id_community = e.community_id
WHERE e.title ILIKE '%' || $1 || '%'
ORDER BY e.start_time ASC;


-- FILTER EVENT BY CATEGORY
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.description,
    e.event_format,
    e.community_id,
    c.title AS community_title
FROM events e
JOIN community c
    ON c.id_community = e.community_id
JOIN event_categories ec
    ON ec.event_id = e.id_event
WHERE ec.category_id = $1
ORDER BY e.start_time ASC;


-- FILTER EVENT BY LOCATION
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.description,
    e.event_format,
    e.community_id,
    c.title AS community_title
FROM events e
JOIN community c
    ON c.id_community = e.community_id
WHERE e.location ILIKE '%' || $1 || '%'
ORDER BY e.start_time ASC;


-- GET EVENT DETAIL
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.description,
    e.event_format,
    e.community_id,
    c.title AS community_title,
    c.images AS community_images
FROM events e
JOIN community c
    ON c.id_community = e.community_id
WHERE e.id_event = $1;


-- GET EVENT CATEGORY
SELECT
    c.id_categories,
    c.name_categories
FROM categories c
JOIN event_categories ec
    ON ec.category_id = c.id_categories
WHERE ec.event_id = $1;


-- GET EVENT SPEAKER
SELECT
    s.id_speaker,
    s.name,
    s.position_job
FROM speaker s
JOIN event_speakers es
    ON es.speaker_id = s.id_speaker
WHERE es.event_id = $1;


-- JOIN EVENT
INSERT INTO user_event (
    users_id,
    events_id
)
VALUES ($1, $2);


-- LEAVE EVENT
DELETE FROM user_event
WHERE users_id = $1
AND events_id = $2;


-- CHECK USER EVENT
SELECT
    users_id,
    events_id
FROM user_event
WHERE users_id = $1
AND events_id = $2;


-- ADD EVENT ATTENDEES
UPDATE events
SET
    attendees = attendees + 1
WHERE id_event = $1
AND attendees < capacity;


-- REMOVE EVENT ATTENDEES
UPDATE events
SET
    attendees = attendees - 1
WHERE id_event = $1
AND attendees > 0;


-- GET UPCOMING EVENT
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.event_format
FROM events e
JOIN user_event ue
    ON ue.events_id = e.id_event
WHERE ue.users_id = $1
AND e.start_time > CURRENT_TIMESTAMP
ORDER BY e.start_time ASC;


-- GET MY EVENT
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.event_format
FROM events e
JOIN user_event ue
    ON ue.events_id = e.id_event
WHERE ue.users_id = $1
ORDER BY e.start_time ASC;


-- GET COMMUNITY LIST
SELECT
    c.id_community,
    c.title,
    c.images,
    c.description,
    COUNT(cm.users_id) AS total_members
FROM community c
LEFT JOIN community_members cm
    ON cm.community_id = c.id_community
GROUP BY
    c.id_community,
    c.title,
    c.images,
    c.description
ORDER BY c.title ASC;


-- SEARCH COMMUNITY
SELECT
    c.id_community,
    c.title,
    c.images,
    c.description
FROM community c
WHERE c.title ILIKE '%' || $1 || '%'
ORDER BY c.title ASC;


-- FILTER COMMUNITY BY CATEGORY
SELECT
    c.id_community,
    c.title,
    c.images,
    c.description
FROM community c
JOIN community_categories cc
    ON cc.community_id = c.id_community
WHERE cc.category_id = $1
ORDER BY c.title ASC;


-- GET COMMUNITY DETAIL
SELECT
    c.id_community,
    c.title,
    c.images,
    c.description,
    c.users_id,
    u.full_name AS organizer_name
FROM community c
LEFT JOIN users u
    ON u.id_users = c.users_id
WHERE c.id_community = $1;


-- GET COMMUNITY CATEGORY
SELECT
    c.id_categories,
    c.name_categories
FROM categories c
JOIN community_categories cc
    ON cc.category_id = c.id_categories
WHERE cc.community_id = $1;


-- GET POPULAR COMMUNITIES
SELECT
    c.id_community,
    c.title,
    c.images,
    c.description,
    COUNT(cm.users_id) AS total_members
FROM community c
LEFT JOIN community_members cm
    ON cm.community_id = c.id_community
GROUP BY
    c.id_community,
    c.title,
    c.images,
    c.description
ORDER BY total_members DESC;


-- JOIN COMMUNITY
INSERT INTO community_members (
    community_id,
    users_id
)
VALUES ($1, $2);


-- LEAVE COMMUNITY
DELETE FROM community_members
WHERE community_id = $1
AND users_id = $2;


-- CHECK COMMUNITY MEMBER
SELECT
    community_id,
    users_id
FROM community_members
WHERE community_id = $1
AND users_id = $2;


-- GET COMMUNITY MEMBER
SELECT
    u.id_users,
    u.full_name,
    u.profile,
    u.job,
    cm.created_at
FROM community_members cm
JOIN users u
    ON u.id_users = cm.users_id
WHERE cm.community_id = $1
ORDER BY cm.created_at ASC;


-- GET USER PROFILE
SELECT
    id_users,
    full_name,
    email,
    bio,
    location,
    profile,
    job,
    created_at,
    update_at
FROM users
WHERE id_users = $1;


-- CHANGE USER PROFILE
UPDATE users
SET
    full_name = $1,
    bio = $2,
    location = $3,
    profile = $4,
    job = $5,
    update_at = CURRENT_TIMESTAMP
WHERE id_users = $6
RETURNING
    id_users,
    full_name,
    email,
    bio,
    location,
    profile,
    job,
    update_at;


-- CHANGE PASSWORD
UPDATE users
SET
    password = $1,
    update_at = CURRENT_TIMESTAMP
WHERE id_users = $2;


-- GET TESTIMONY
SELECT
    t.id_testimonial,
    t.text,
    t.users_id,
    u.full_name,
    u.profile
FROM testimonials t
JOIN users u
    ON u.id_users = t.users_id
ORDER BY t.id_testimonial DESC;


-- SET TESTIMONY
INSERT INTO testimonials (
    text,
    users_id
)
VALUES ($1, $2)
RETURNING
    id_testimonial,
    text,
    users_id;


-- GET MY NOTIFICATION
SELECT
    id_notification,
    title,
    description,
    time,
    type,
    read_at
FROM notifications
WHERE users_id = $1
ORDER BY time DESC;


-- GET ORGANIZER COMMUNITY
SELECT
    id_community,
    title,
    images,
    description
FROM community
WHERE users_id = $1;


-- GET ORGANIZER EVENT
SELECT
    e.id_event,
    e.title,
    e.images,
    e.start_time,
    e.end_time,
    e.location,
    e.attendees,
    e.capacity,
    e.description,
    e.event_format
FROM events e
JOIN community c
    ON c.id_community = e.community_id
WHERE c.users_id = $1
ORDER BY e.start_time ASC;


-- CREATE EVENT
INSERT INTO events (
    title,
    images,
    start_time,
    end_time,
    location,
    capacity,
    description,
    event_format,
    community_id
)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
RETURNING id_event;


-- EDIT EVENT
UPDATE events
SET
    title = $1,
    images = $2,
    start_time = $3,
    end_time = $4,
    location = $5,
    capacity = $6,
    description = $7,
    event_format = $8
WHERE id_event = $9
RETURNING
    id_event,
    title,
    images,
    start_time,
    end_time,
    location,
    capacity,
    description,
    event_format;


-- ADD EVENT CATEGORY
INSERT INTO event_categories (
    event_id,
    category_id
)
VALUES ($1, $2);


-- ADD EVENT SPEAKER
INSERT INTO event_speakers (
    event_id,
    speaker_id
)
VALUES ($1, $2);


-- GET ADMIN TOTAL USERS
SELECT COUNT(*)
FROM users;


-- GET ADMIN TOTAL EVENTS
SELECT COUNT(*)
FROM events;


-- GET ADMIN TOTAL COMMUNITIES
SELECT COUNT(*)
FROM community;


-- GET ADMIN TOTAL EVENT MEMBERS
SELECT COUNT(*)
FROM user_event;


-- GET ADMIN TOTAL COMMUNITY MEMBERS
SELECT COUNT(*)
FROM community_members;