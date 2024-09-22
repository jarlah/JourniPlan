# JourniPlan

**JourniPlan** is an open-source travel planner and micro journaling app that helps you organize and document your trips in one place. 

## Features
- **Day-by-Day Itinerary Planner**: Plan your activities, destinations, and events for each day of your trip.
- **Micro Journaling**: Capture thoughts, photos, and videos as you go, with location-based check-ins and journaling prompts.
- **Maps & Directions**: Seamless integration with maps to help navigate between planned destinations.
- **Collaborative Trip Planning**: Share and collaborate on itineraries with friends or family.
- **Expense & Budget Tracking**: Monitor your spending and stay within your budget.
- **Offline Mode**: Access your plans and journals even without an internet connection.

Built using **Elixir** and **Phoenix LiveView**, JourniPlan aims to provide a seamless and interactive experience for travelers looking to plan and preserve memories of their adventures.

## ER diagram (WIP)

```mermaid
erDiagram
    USER {
        int user_id PK
        string email
        string hashed_password
    }
    ITINERARY {
        int itinerary_id PK
        string title
        string description
        int user_id FK
    }
    ACTIVITY {
        int activity_id PK
        string name
        string description
        datetime start_time
        datetime end_time
        int itinerary_id FK
    }
    JOURNAL_ENTRY {
        int journal_entry_id PK
        string title
        string body
        date entry_date
        int activity_id FK
        int itinerary_id FK
        int user_id FK
    }
    MEDIA {
        int media_id PK
        string media_type
        bytea media_blob
    }
    MEDIA_ITINERARY {
        int media_id PK, FK
        int itinerary_id PK, FK
    }
    MEDIA_ACTIVITY {
        int media_id PK, FK
        int activity_id PK, FK
    }
    MEDIA_JOURNAL_ENTRY {
        int media_id PK, FK
        int journal_entry_id PK, FK
    }

    ITINERARY ||--o{ MEDIA_ITINERARY : has
    MEDIA ||--o{ MEDIA_ITINERARY : includes
    ACTIVITY ||--o{ MEDIA_ACTIVITY : has
    MEDIA ||--o{ MEDIA_ACTIVITY : includes
    JOURNAL_ENTRY ||--o{ MEDIA_JOURNAL_ENTRY : has
    MEDIA ||--o{ MEDIA_JOURNAL_ENTRY : includes

    USER ||--o{ ITINERARY : owns
    USER ||--o{ JOURNAL_ENTRY : creates
    ITINERARY ||--o{ ACTIVITY : contains
    JOURNAL_ENTRY ||--o{ ACTIVITY : refers_to
    JOURNAL_ENTRY ||--o{ ITINERARY : belongs_to
```

## Start server 

To start your Phoenix server:

  * Run `docker run --name some-postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgre` (testcontainers for elixir doesnt have support for multiple repos yet ...)
  * Run `mix reset` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
