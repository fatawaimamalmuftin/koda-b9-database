```mermaid
erDiagram

    Users {
        id_users int PK
        fullName string
        email string
        password string
        confirmPassword string
        agree boolean
        bio string
        location string
        profile string
        created_at datetime
    }

    cart {
        users_id int FK
        events_id int FK
    }

    speaker {
        id_speaker int PK
        name string
        title string
    }

    categories {
        id_categories int PK
        name_categories string
    }

    events {
        id_event int PK
        title string
        images string
        date date
        time startTime
        time endTime
        location string
        attendees int
        capacity int
        description string
        eventFormat string
        categories_id int FK
        community_id int FK
    }

    event_speakers {
        event_id int FK
        speaker_id int FK
    }

    community {
        id_community int PK
        title string
        images string
        description string
        members int
        upcoming int
        categories_id int FK
        users_id int FK
    }

    community_members {
        community_id int FK
        users_id int FK
    }

    notifications {
        id_notification int PK
        title string
        description string
        time datetime
        type string
        unread boolean
        users_id int FK
    }


    Users ||--o{ cart : have
    events ||--o{ cart : container

    categories ||--o{ events : categories
    community ||--o{ events : organizes

    speaker ||--o{ event_speakers : join
    events ||--o{ event_speakers : have

    categories ||--o{ community : categories

    Users ||--o{ community : create
    Users ||--o{ community_members : join
    community ||--o{ community_members : have

    Users ||--o{ notifications : notif
```

![https://dbdiagram.io/d/koda-b9-database-6aafed6c943b561dd493eaa3](./images/dbDiagram.png)