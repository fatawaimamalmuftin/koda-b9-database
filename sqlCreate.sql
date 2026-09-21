CREATE TABLE "Users" (
  "id_users" int PRIMARY KEY,
  "fullName" varchar,
  "email" varchar,
  "password" varchar,
  "confirmPassword" varchar,
  "agree" boolean,
  "bio" text,
  "location" varchar,
  "profile" text,
  "created_at" datetime
);

CREATE TABLE "cart" (
  "users_id" int NOT NULL,
  "events_id" int NOT NULL
);

CREATE TABLE "speaker" (
  "id_speaker" int PRIMARY KEY,
  "name" varchar,
  "pocition_job" varchar
);

CREATE TABLE "categories" (
  "id_categories" int PRIMARY KEY,
  "name_categories" varchar
);

CREATE TABLE "events" (
  "id_event" int PRIMARY KEY,
  "title" varchar,
  "images" text,
  "startTime" datetime,
  "endTime" datetime,
  "location" varchar,
  "attendees" int,
  "capacity" int,
  "description" text,
  "eventFormat" varchar,
  "community_id" int NOT NULL
);

CREATE TABLE "event_categories" (
  "event_id" int NOT NULL,
  "category_id" int NOT NULL
);

CREATE TABLE "event_speakers" (
  "event_id" int NOT NULL,
  "speaker_id" int NOT NULL
);

CREATE TABLE "community" (
  "id_community" int PRIMARY KEY,
  "title" varchar,
  "images" text,
  "description" text,
  "members" int,
  "upcoming" int,
  "users_id" int NOT NULL
);

CREATE TABLE "community_categories" (
  "community_id" int NOT NULL,
  "category_id" int NOT NULL
);

CREATE TABLE "community_members" (
  "community_id" int NOT NULL,
  "users_id" int NOT NULL
);

CREATE TABLE "notifications" (
  "id_notification" int PRIMARY KEY,
  "title" varchar,
  "description" text,
  "time" datetime,
  "type" varchar,
  "is_read" datetime,
  "users_id" int NOT NULL
);

CREATE TABLE "testimonials" (
  "id_testimonial" int PRIMARY KEY,
  "text" text,
  "name" varchar,
  "job" varchar,
  "profile" varchar,
  "users_id" int NOT NULL
);

CREATE TABLE "event_discusstion" (
  "id_discuss" int PRIMARY KEY,
  "massage" text,
  "created_at" timestamp,
  "event_id" int NOT NULL,
  "user_id" int NOT NULL
);

ALTER TABLE "cart" ADD FOREIGN KEY ("users_id") REFERENCES "Users" ("id_users") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "cart" ADD FOREIGN KEY ("events_id") REFERENCES "events" ("id_event") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "events" ADD FOREIGN KEY ("community_id") REFERENCES "community" ("id_community") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "event_categories" ADD FOREIGN KEY ("event_id") REFERENCES "events" ("id_event") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "event_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id_categories") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "event_speakers" ADD FOREIGN KEY ("event_id") REFERENCES "events" ("id_event") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "event_speakers" ADD FOREIGN KEY ("speaker_id") REFERENCES "speaker" ("id_speaker") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "community" ADD FOREIGN KEY ("users_id") REFERENCES "Users" ("id_users") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "community_categories" ADD FOREIGN KEY ("community_id") REFERENCES "community" ("id_community") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "community_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id_categories") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "community_members" ADD FOREIGN KEY ("community_id") REFERENCES "community" ("id_community") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "community_members" ADD FOREIGN KEY ("users_id") REFERENCES "Users" ("id_users") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "notifications" ADD FOREIGN KEY ("users_id") REFERENCES "Users" ("id_users") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "testimonials" ADD FOREIGN KEY ("users_id") REFERENCES "Users" ("id_users") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "event_discusstion" ADD FOREIGN KEY ("event_id") REFERENCES "events" ("id_event") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "event_discusstion" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id_users") DEFERRABLE INITIALLY IMMEDIATE;