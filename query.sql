-- 1
SELECT 
id_users, full_name, email, password, bio, location, profile
FROM users
WHERE email = 'emailuser@mail.com';

-- 2
INSERT INTO users (
    full_name,
    email,
    password,
    bio,
    location,
    profile,
    agree
)

-- 3
