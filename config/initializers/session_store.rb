Rails.application.config.session_store :active_record_store, key: '_real_world_rpg_session', secure: Rails.env.production?
