-- ENUM
CREATE TYPE event_format AS ENUM ('in person','online');

CREATE TYPE type_icon AS ENUM ('event','register','community','update','message');

-- USERS
CREATE TABLE users (
    id_users INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    bio TEXT,
    location VARCHAR(255),
    profile VARCHAR(255),
    job VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SPEAKER
CREATE TABLE speaker (
    id_speaker INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position_job VARCHAR(255) NOT NULL
);

-- CATEGORIES
CREATE TABLE categories (
    id_categories INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name_categories VARCHAR(255) NOT NULL UNIQUE
);

-- COMMUNITY
CREATE TABLE community (
    id_community INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    images TEXT,
    description TEXT,
    users_id INT,

    CONSTRAINT fk_community_user FOREIGN KEY (users_id) REFERENCES users(id_users)
);

-- EVENTS
CREATE TABLE events (
    id_event INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    images TEXT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    location VARCHAR(255),
    attendees INT NOT NULL DEFAULT 0,
    capacity INT NOT NULL,
    description TEXT,
    event_format event_format NOT NULL DEFAULT 'in person',
    community_id INT NOT NULL,

    CONSTRAINT fk_event_community FOREIGN KEY (community_id) REFERENCES community(id_community),

    CONSTRAINT check_event_attendees CHECK (attendees >= 0),
    CONSTRAINT check_event_capacity CHECK (capacity > 0),
    CONSTRAINT check_event_attendees_capacity CHECK (attendees <= capacity),
    CONSTRAINT check_event_time CHECK (start_time < end_time)
);

-- USER EVENT
CREATE TABLE user_event (
    users_id INT NOT NULL,
    events_id INT NOT NULL,

    PRIMARY KEY (users_id, events_id),

    CONSTRAINT fk_user_event_user FOREIGN KEY (users_id) REFERENCES users(id_users),

    CONSTRAINT fk_user_event_event FOREIGN KEY (events_id) REFERENCES events(id_event)
);

-- EVENT CATEGORIES
CREATE TABLE event_categories (
    event_id INT NOT NULL,
    category_id INT NOT NULL,

    PRIMARY KEY (event_id, category_id),

    CONSTRAINT fk_event_categories_event FOREIGN KEY (event_id) REFERENCES events(id_event),

    CONSTRAINT fk_event_categories_category FOREIGN KEY (category_id) REFERENCES categories(id_categories)
);

-- EVENT SPEAKERS
CREATE TABLE event_speakers (
    event_id INT NOT NULL,
    speaker_id INT NOT NULL,

    PRIMARY KEY (event_id, speaker_id),

    CONSTRAINT fk_event_speakers_event FOREIGN KEY (event_id) REFERENCES events(id_event),

    CONSTRAINT fk_event_speakers_speaker FOREIGN KEY (speaker_id) REFERENCES speaker(id_speaker)
);

-- COMMUNITY CATEGORIES
CREATE TABLE community_categories (
    community_id INT NOT NULL,
    category_id INT NOT NULL,

    PRIMARY KEY (community_id, category_id),

    CONSTRAINT fk_community_categories_community FOREIGN KEY (community_id) REFERENCES community(id_community),

    CONSTRAINT fk_community_categories_category FOREIGN KEY (category_id) REFERENCES categories(id_categories)
);

-- COMMUNITY MEMBERS
CREATE TABLE community_members (
    community_id INT NOT NULL,
    users_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (community_id, users_id),

    CONSTRAINT fk_community_members_community FOREIGN KEY (community_id) REFERENCES community(id_community),

    CONSTRAINT fk_community_members_user FOREIGN KEY (users_id) REFERENCES users(id_users)
);

-- NOTIFICATIONS
CREATE TABLE notifications (
    id_notification INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    type type_icon NOT NULL,
    read_at TIMESTAMP,
    users_id INT NOT NULL,

    CONSTRAINT fk_notifications_user FOREIGN KEY (users_id) REFERENCES users(id_users)
);

-- TESTIMONIALS
CREATE TABLE testimonials (
    id_testimonial INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    text TEXT NOT NULL,
    users_id INT NOT NULL,

    CONSTRAINT fk_testimonials_user FOREIGN KEY (users_id) REFERENCES users(id_users)
);

-- EVENT DISCUSSION
CREATE TABLE event_discussion (
    id_discuss INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    message TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    event_id INT NOT NULL,
    user_id INT NOT NULL,

    CONSTRAINT fk_event_discussion_event FOREIGN KEY (event_id) REFERENCES events(id_event),

    CONSTRAINT fk_event_discussion_user FOREIGN KEY (user_id) REFERENCES users(id_users)
);