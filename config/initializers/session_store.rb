Rails.application.config.session_store :cookie_store, key: '_real_world_rpg_session', secure: Rails.env.production?
