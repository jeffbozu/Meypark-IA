export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      accessibility_prefs: {
        Row: {
          combo_json: Json
          created_at: string
          device_id: string
          id: string
        }
        Insert: {
          combo_json?: Json
          created_at?: string
          device_id: string
          id?: string
        }
        Update: {
          combo_json?: Json
          created_at?: string
          device_id?: string
          id?: string
        }
        Relationships: [
          {
            foreignKeyName: "accessibility_prefs_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      ai_settings: {
        Row: {
          a11y_remember_last5: boolean
          company_id: string
          created_at: string
          device_id: string | null
          id: string
          layout_adaptive_tts: boolean
          maintenance_predictive: boolean
          master_on: boolean
          pay_promotion: boolean
          pay_reco_last5: boolean
          presets_smart: boolean
          queue_mode: boolean
          updated_at: string
        }
        Insert: {
          a11y_remember_last5?: boolean
          company_id: string
          created_at?: string
          device_id?: string | null
          id?: string
          layout_adaptive_tts?: boolean
          maintenance_predictive?: boolean
          master_on?: boolean
          pay_promotion?: boolean
          pay_reco_last5?: boolean
          presets_smart?: boolean
          queue_mode?: boolean
          updated_at?: string
        }
        Update: {
          a11y_remember_last5?: boolean
          company_id?: string
          created_at?: string
          device_id?: string | null
          id?: string
          layout_adaptive_tts?: boolean
          maintenance_predictive?: boolean
          master_on?: boolean
          pay_promotion?: boolean
          pay_reco_last5?: boolean
          presets_smart?: boolean
          queue_mode?: boolean
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "ai_settings_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ai_settings_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      alerts: {
        Row: {
          closed_at: string | null
          closed_by: string | null
          created_at: string
          device_id: string
          id: string
          info_json: Json
          status: Database["public"]["Enums"]["alert_status"]
          type: Database["public"]["Enums"]["alert_type"]
        }
        Insert: {
          closed_at?: string | null
          closed_by?: string | null
          created_at?: string
          device_id: string
          id?: string
          info_json?: Json
          status?: Database["public"]["Enums"]["alert_status"]
          type: Database["public"]["Enums"]["alert_type"]
        }
        Update: {
          closed_at?: string | null
          closed_by?: string | null
          created_at?: string
          device_id?: string
          id?: string
          info_json?: Json
          status?: Database["public"]["Enums"]["alert_status"]
          type?: Database["public"]["Enums"]["alert_type"]
        }
        Relationships: [
          {
            foreignKeyName: "alerts_closed_by_fkey"
            columns: ["closed_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "alerts_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      audit_logs: {
        Row: {
          action: string
          actor_role: Database["public"]["Enums"]["user_role"]
          actor_user_id: string | null
          created_at: string
          diff_json: Json
          id: string
          target_id: string
          target_type: string
        }
        Insert: {
          action: string
          actor_role: Database["public"]["Enums"]["user_role"]
          actor_user_id?: string | null
          created_at?: string
          diff_json?: Json
          id?: string
          target_id: string
          target_type: string
        }
        Update: {
          action?: string
          actor_role?: Database["public"]["Enums"]["user_role"]
          actor_user_id?: string | null
          created_at?: string
          diff_json?: Json
          id?: string
          target_id?: string
          target_type?: string
        }
        Relationships: [
          {
            foreignKeyName: "audit_logs_actor_user_id_fkey"
            columns: ["actor_user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      companies: {
        Row: {
          address_json: Json
          api_base_url: string | null
          api_endpoints_json: Json | null
          api_token: string | null
          cif: string
          created_at: string
          features_json: Json | null
          id: string
          mode: Database["public"]["Enums"]["company_mode"]
          name: string
          payload_mappings_json: Json | null
          updated_at: string
        }
        Insert: {
          address_json?: Json
          api_base_url?: string | null
          api_endpoints_json?: Json | null
          api_token?: string | null
          cif: string
          created_at?: string
          features_json?: Json | null
          id?: string
          mode?: Database["public"]["Enums"]["company_mode"]
          name: string
          payload_mappings_json?: Json | null
          updated_at?: string
        }
        Update: {
          address_json?: Json
          api_base_url?: string | null
          api_endpoints_json?: Json | null
          api_token?: string | null
          cif?: string
          created_at?: string
          features_json?: Json | null
          id?: string
          mode?: Database["public"]["Enums"]["company_mode"]
          name?: string
          payload_mappings_json?: Json | null
          updated_at?: string
        }
        Relationships: []
      }
      device_command_results: {
        Row: {
          command_id: string
          completed_at: string
          exit_code: number | null
          id: string
          result_json: Json
        }
        Insert: {
          command_id: string
          completed_at?: string
          exit_code?: number | null
          id?: string
          result_json?: Json
        }
        Update: {
          command_id?: string
          completed_at?: string
          exit_code?: number | null
          id?: string
          result_json?: Json
        }
        Relationships: [
          {
            foreignKeyName: "device_command_results_command_id_fkey"
            columns: ["command_id"]
            isOneToOne: false
            referencedRelation: "device_commands"
            referencedColumns: ["id"]
          },
        ]
      }
      device_commands: {
        Row: {
          action: Database["public"]["Enums"]["command_action"]
          device_id: string
          id: string
          payload_json: Json
          requested_at: string
          requested_by: string | null
          status: Database["public"]["Enums"]["command_status"]
        }
        Insert: {
          action: Database["public"]["Enums"]["command_action"]
          device_id: string
          id?: string
          payload_json?: Json
          requested_at?: string
          requested_by?: string | null
          status?: Database["public"]["Enums"]["command_status"]
        }
        Update: {
          action?: Database["public"]["Enums"]["command_action"]
          device_id?: string
          id?: string
          payload_json?: Json
          requested_at?: string
          requested_by?: string | null
          status?: Database["public"]["Enums"]["command_status"]
        }
        Relationships: [
          {
            foreignKeyName: "device_commands_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "device_commands_requested_by_fkey"
            columns: ["requested_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      device_logs: {
        Row: {
          context_json: Json
          device_id: string
          id: string
          level: Database["public"]["Enums"]["log_level"]
          message: string
          ts: string
        }
        Insert: {
          context_json?: Json
          device_id: string
          id?: string
          level: Database["public"]["Enums"]["log_level"]
          message: string
          ts?: string
        }
        Update: {
          context_json?: Json
          device_id?: string
          id?: string
          level?: Database["public"]["Enums"]["log_level"]
          message?: string
          ts?: string
        }
        Relationships: [
          {
            foreignKeyName: "device_logs_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      devices: {
        Row: {
          alias: string
          app_version: string | null
          company_id: string
          created_at: string
          flags_json: Json | null
          id: string
          last_seen: string | null
          serial: string
          timezone: string
          updated_at: string
        }
        Insert: {
          alias: string
          app_version?: string | null
          company_id: string
          created_at?: string
          flags_json?: Json | null
          id?: string
          last_seen?: string | null
          serial: string
          timezone?: string
          updated_at?: string
        }
        Update: {
          alias?: string
          app_version?: string | null
          company_id?: string
          created_at?: string
          flags_json?: Json | null
          id?: string
          last_seen?: string | null
          serial?: string
          timezone?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "devices_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      external_integrations: {
        Row: {
          base_url: string
          company_id: string
          created_at: string
          enabled: boolean
          endpoints_json: Json
          id: string
          mapping_json: Json
          name: string
          rate_limit_json: Json
          token: string | null
          updated_at: string
        }
        Insert: {
          base_url: string
          company_id: string
          created_at?: string
          enabled?: boolean
          endpoints_json?: Json
          id?: string
          mapping_json?: Json
          name: string
          rate_limit_json?: Json
          token?: string | null
          updated_at?: string
        }
        Update: {
          base_url?: string
          company_id?: string
          created_at?: string
          enabled?: boolean
          endpoints_json?: Json
          id?: string
          mapping_json?: Json
          name?: string
          rate_limit_json?: Json
          token?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "external_integrations_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      external_zone_cache: {
        Row: {
          company_id: string
          id: string
          origin_key: string
          payload_json: Json
          synced_at: string
        }
        Insert: {
          company_id: string
          id?: string
          origin_key: string
          payload_json?: Json
          synced_at?: string
        }
        Update: {
          company_id?: string
          id?: string
          origin_key?: string
          payload_json?: Json
          synced_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "external_zone_cache_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      feature_flags: {
        Row: {
          company_id: string
          created_at: string
          device_id: string | null
          id: string
          key: string
          updated_at: string
          value_json: Json
        }
        Insert: {
          company_id: string
          created_at?: string
          device_id?: string | null
          id?: string
          key: string
          updated_at?: string
          value_json?: Json
        }
        Update: {
          company_id?: string
          created_at?: string
          device_id?: string | null
          id?: string
          key?: string
          updated_at?: string
          value_json?: Json
        }
        Relationships: [
          {
            foreignKeyName: "feature_flags_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "feature_flags_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      fines: {
        Row: {
          amount_cents: number
          cancelled_at: string | null
          company_id: string
          country: string
          created_at: string
          geo: Json | null
          id: string
          inspector_id: string | null
          paid_at: string | null
          photo_url: string | null
          plate: string
          reason: string | null
          status: Database["public"]["Enums"]["fine_status"]
        }
        Insert: {
          amount_cents: number
          cancelled_at?: string | null
          company_id: string
          country?: string
          created_at?: string
          geo?: Json | null
          id?: string
          inspector_id?: string | null
          paid_at?: string | null
          photo_url?: string | null
          plate: string
          reason?: string | null
          status?: Database["public"]["Enums"]["fine_status"]
        }
        Update: {
          amount_cents?: number
          cancelled_at?: string | null
          company_id?: string
          country?: string
          created_at?: string
          geo?: Json | null
          id?: string
          inspector_id?: string | null
          paid_at?: string | null
          photo_url?: string | null
          plate?: string
          reason?: string | null
          status?: Database["public"]["Enums"]["fine_status"]
        }
        Relationships: [
          {
            foreignKeyName: "fines_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fines_inspector_id_fkey"
            columns: ["inspector_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      invoices: {
        Row: {
          created_at: string
          hash_demo: string | null
          id: string
          pdf_url: string | null
          ticket_id: string
        }
        Insert: {
          created_at?: string
          hash_demo?: string | null
          id?: string
          pdf_url?: string | null
          ticket_id: string
        }
        Update: {
          created_at?: string
          hash_demo?: string | null
          id?: string
          pdf_url?: string | null
          ticket_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "invoices_ticket_id_fkey"
            columns: ["ticket_id"]
            isOneToOne: true
            referencedRelation: "tickets"
            referencedColumns: ["id"]
          },
        ]
      }
      license_patterns: {
        Row: {
          country: string
          example: string
          regex: string
        }
        Insert: {
          country: string
          example: string
          regex: string
        }
        Update: {
          country?: string
          example?: string
          regex?: string
        }
        Relationships: []
      }
      ota_jobs: {
        Row: {
          created_at: string
          device_id: string
          id: string
          release_id: string
          scheduled_at: string
        }
        Insert: {
          created_at?: string
          device_id: string
          id?: string
          release_id: string
          scheduled_at: string
        }
        Update: {
          created_at?: string
          device_id?: string
          id?: string
          release_id?: string
          scheduled_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "ota_jobs_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ota_jobs_release_id_fkey"
            columns: ["release_id"]
            isOneToOne: false
            referencedRelation: "ota_releases"
            referencedColumns: ["id"]
          },
        ]
      }
      ota_releases: {
        Row: {
          checksum: string | null
          created_at: string
          file_url: string | null
          id: string
          notes: string | null
          version: string
        }
        Insert: {
          checksum?: string | null
          created_at?: string
          file_url?: string | null
          id?: string
          notes?: string | null
          version: string
        }
        Update: {
          checksum?: string | null
          created_at?: string
          file_url?: string | null
          id?: string
          notes?: string | null
          version?: string
        }
        Relationships: []
      }
      ota_status: {
        Row: {
          device_id: string
          id: string
          job_id: string
          status: Database["public"]["Enums"]["ota_job_status"]
          updated_at: string
        }
        Insert: {
          device_id: string
          id?: string
          job_id: string
          status?: Database["public"]["Enums"]["ota_job_status"]
          updated_at?: string
        }
        Update: {
          device_id?: string
          id?: string
          job_id?: string
          status?: Database["public"]["Enums"]["ota_job_status"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "ota_status_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ota_status_job_id_fkey"
            columns: ["job_id"]
            isOneToOne: false
            referencedRelation: "ota_jobs"
            referencedColumns: ["id"]
          },
        ]
      }
      payments: {
        Row: {
          created_at: string
          id: string
          payload_json: Json
          provider: Database["public"]["Enums"]["payment_provider"]
          status: Database["public"]["Enums"]["payment_status"]
          ticket_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          payload_json?: Json
          provider: Database["public"]["Enums"]["payment_provider"]
          status?: Database["public"]["Enums"]["payment_status"]
          ticket_id: string
        }
        Update: {
          created_at?: string
          id?: string
          payload_json?: Json
          provider?: Database["public"]["Enums"]["payment_provider"]
          status?: Database["public"]["Enums"]["payment_status"]
          ticket_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "payments_ticket_id_fkey"
            columns: ["ticket_id"]
            isOneToOne: false
            referencedRelation: "tickets"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          company_id: string | null
          created_at: string
          id: string
          locale: string
          role: Database["public"]["Enums"]["user_role"]
        }
        Insert: {
          company_id?: string | null
          created_at?: string
          id: string
          locale?: string
          role: Database["public"]["Enums"]["user_role"]
        }
        Update: {
          company_id?: string | null
          created_at?: string
          id?: string
          locale?: string
          role?: Database["public"]["Enums"]["user_role"]
        }
        Relationships: [
          {
            foreignKeyName: "profiles_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      tariffs: {
        Row: {
          created_at: string
          id: string
          max_minutes: number
          min_minutes: number
          presets_json: Json
          price_per_min_cents: number
          step_minutes: number
          updated_at: string
          zone_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          max_minutes?: number
          min_minutes?: number
          presets_json?: Json
          price_per_min_cents: number
          step_minutes?: number
          updated_at?: string
          zone_id: string
        }
        Update: {
          created_at?: string
          id?: string
          max_minutes?: number
          min_minutes?: number
          presets_json?: Json
          price_per_min_cents?: number
          step_minutes?: number
          updated_at?: string
          zone_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "tariffs_zone_id_fkey"
            columns: ["zone_id"]
            isOneToOne: false
            referencedRelation: "zones"
            referencedColumns: ["id"]
          },
        ]
      }
      telemetry_current: {
        Row: {
          battery: number | null
          coin_level: number | null
          device_id: string
          emv_state: string | null
          paper_pct: number | null
          printer_state: string | null
          rssi: number | null
          temp_c: number | null
          updated_at: string
        }
        Insert: {
          battery?: number | null
          coin_level?: number | null
          device_id: string
          emv_state?: string | null
          paper_pct?: number | null
          printer_state?: string | null
          rssi?: number | null
          temp_c?: number | null
          updated_at?: string
        }
        Update: {
          battery?: number | null
          coin_level?: number | null
          device_id?: string
          emv_state?: string | null
          paper_pct?: number | null
          printer_state?: string | null
          rssi?: number | null
          temp_c?: number | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "telemetry_current_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: true
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      telemetry_history: {
        Row: {
          device_id: string
          id: string
          metric: string
          ts: string
          value: number
        }
        Insert: {
          device_id: string
          id?: string
          metric: string
          ts?: string
          value: number
        }
        Update: {
          device_id?: string
          id?: string
          metric?: string
          ts?: string
          value?: number
        }
        Relationships: [
          {
            foreignKeyName: "telemetry_history_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      themes: {
        Row: {
          colors_json: Json
          company_id: string
          created_at: string
          id: string
          scope: Database["public"]["Enums"]["theme_scope"]
          updated_at: string
        }
        Insert: {
          colors_json?: Json
          company_id: string
          created_at?: string
          id?: string
          scope: Database["public"]["Enums"]["theme_scope"]
          updated_at?: string
        }
        Update: {
          colors_json?: Json
          company_id?: string
          created_at?: string
          id?: string
          scope?: Database["public"]["Enums"]["theme_scope"]
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "themes_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      ticket_templates: {
        Row: {
          company_id: string
          created_at: string
          fields_json: Json
          footer_text: string | null
          id: string
          show_qr: boolean
          updated_at: string
        }
        Insert: {
          company_id: string
          created_at?: string
          fields_json?: Json
          footer_text?: string | null
          id?: string
          show_qr?: boolean
          updated_at?: string
        }
        Update: {
          company_id?: string
          created_at?: string
          fields_json?: Json
          footer_text?: string | null
          id?: string
          show_qr?: boolean
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "ticket_templates_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      tickets: {
        Row: {
          amount_cents: number
          company_id: string
          country: string
          created_at: string
          device_id: string
          duration_min: number
          end_ts: string
          id: string
          invoice_qr_url: string | null
          invoice_token: string | null
          parent_ticket_id: string | null
          pay_method: Database["public"]["Enums"]["payment_provider"]
          plate: string
          start_ts: string
          status: Database["public"]["Enums"]["ticket_status"]
          updated_at: string
          zone_id: string
        }
        Insert: {
          amount_cents: number
          company_id: string
          country?: string
          created_at?: string
          device_id: string
          duration_min: number
          end_ts: string
          id?: string
          invoice_qr_url?: string | null
          invoice_token?: string | null
          parent_ticket_id?: string | null
          pay_method: Database["public"]["Enums"]["payment_provider"]
          plate: string
          start_ts: string
          status?: Database["public"]["Enums"]["ticket_status"]
          updated_at?: string
          zone_id: string
        }
        Update: {
          amount_cents?: number
          company_id?: string
          country?: string
          created_at?: string
          device_id?: string
          duration_min?: number
          end_ts?: string
          id?: string
          invoice_qr_url?: string | null
          invoice_token?: string | null
          parent_ticket_id?: string | null
          pay_method?: Database["public"]["Enums"]["payment_provider"]
          plate?: string
          start_ts?: string
          status?: Database["public"]["Enums"]["ticket_status"]
          updated_at?: string
          zone_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "tickets_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tickets_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tickets_parent_ticket_id_fkey"
            columns: ["parent_ticket_id"]
            isOneToOne: false
            referencedRelation: "tickets"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tickets_zone_id_fkey"
            columns: ["zone_id"]
            isOneToOne: false
            referencedRelation: "zones"
            referencedColumns: ["id"]
          },
        ]
      }
      ui_overrides: {
        Row: {
          company_id: string
          created_at: string
          device_id: string | null
          id: string
          scope: Database["public"]["Enums"]["ui_scope"]
          text_overrides_json: Json
          updated_at: string
          visibility_json: Json
        }
        Insert: {
          company_id: string
          created_at?: string
          device_id?: string | null
          id?: string
          scope: Database["public"]["Enums"]["ui_scope"]
          text_overrides_json?: Json
          updated_at?: string
          visibility_json?: Json
        }
        Update: {
          company_id?: string
          created_at?: string
          device_id?: string | null
          id?: string
          scope?: Database["public"]["Enums"]["ui_scope"]
          text_overrides_json?: Json
          updated_at?: string
          visibility_json?: Json
        }
        Relationships: [
          {
            foreignKeyName: "ui_overrides_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ui_overrides_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      usage_stats: {
        Row: {
          device_id: string
          id: string
          metric: string
          ts: string
          value: number
        }
        Insert: {
          device_id: string
          id?: string
          metric: string
          ts?: string
          value: number
        }
        Update: {
          device_id?: string
          id?: string
          metric?: string
          ts?: string
          value?: number
        }
        Relationships: [
          {
            foreignKeyName: "usage_stats_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
        ]
      }
      zone_calendars: {
        Row: {
          calendar_json: Json
          created_at: string
          id: string
          valid_from: string
          valid_to: string
          zone_id: string
        }
        Insert: {
          calendar_json?: Json
          created_at?: string
          id?: string
          valid_from: string
          valid_to: string
          zone_id: string
        }
        Update: {
          calendar_json?: Json
          created_at?: string
          id?: string
          valid_from?: string
          valid_to?: string
          zone_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "zone_calendars_zone_id_fkey"
            columns: ["zone_id"]
            isOneToOne: false
            referencedRelation: "zones"
            referencedColumns: ["id"]
          },
        ]
      }
      zones: {
        Row: {
          code: string
          color: string
          company_id: string
          created_at: string
          id: string
          is_active: boolean
          name: string
          schedule_json: Json
          updated_at: string
        }
        Insert: {
          code: string
          color?: string
          company_id: string
          created_at?: string
          id?: string
          is_active?: boolean
          name: string
          schedule_json?: Json
          updated_at?: string
        }
        Update: {
          code?: string
          color?: string
          company_id?: string
          created_at?: string
          id?: string
          is_active?: boolean
          name?: string
          schedule_json?: Json
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "zones_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      active_sessions_v: {
        Row: {
          amount_total_cents: number | null
          company_id: string | null
          country: string | null
          device_id: string | null
          invoice_qr_url: string | null
          invoice_token: string | null
          method_last: Database["public"]["Enums"]["payment_provider"] | null
          paid_until_ts: string | null
          plate: string | null
          remaining_min: number | null
          start_ts: string | null
          status: Database["public"]["Enums"]["ticket_status"] | null
          zone_id: string | null
        }
        Relationships: [
          {
            foreignKeyName: "tickets_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tickets_device_id_fkey"
            columns: ["device_id"]
            isOneToOne: false
            referencedRelation: "devices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tickets_zone_id_fkey"
            columns: ["zone_id"]
            isOneToOne: false
            referencedRelation: "zones"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Functions: {
      get_user_context: {
        Args: Record<PropertyKey, never>
        Returns: {
          company_id: string
          role: Database["public"]["Enums"]["user_role"]
        }[]
      }
      gtrgm_compress: {
        Args: { "": unknown }
        Returns: unknown
      }
      gtrgm_decompress: {
        Args: { "": unknown }
        Returns: unknown
      }
      gtrgm_in: {
        Args: { "": unknown }
        Returns: unknown
      }
      gtrgm_options: {
        Args: { "": unknown }
        Returns: undefined
      }
      gtrgm_out: {
        Args: { "": unknown }
        Returns: unknown
      }
      set_limit: {
        Args: { "": number }
        Returns: number
      }
      show_limit: {
        Args: Record<PropertyKey, never>
        Returns: number
      }
      show_trgm: {
        Args: { "": string }
        Returns: string[]
      }
      uuid_generate_v4: {
        Args: Record<PropertyKey, never>
        Returns: string
      }
    }
    Enums: {
      alert_status: "open" | "closed"
      alert_type:
        | "paper_low_20"
        | "paper_low_10"
        | "emv_off"
        | "rssi_low"
        | "temp_high"
        | "power_issue"
      command_action:
        | "OPEN_PAYMENT_WITH_DURATION"
        | "SET_A11Y_PROFILE"
        | "SCREENSHOT"
        | "PRINT_TEST"
        | "REFRESH_TARIFFS"
        | "RESTART_UI"
        | "PING_EMV"
        | "CHANGE_COMPANY"
        | "PUSH_THEME"
      command_status: "queued" | "in_progress" | "done" | "error"
      company_mode: "local" | "api_externa"
      fine_status: "active" | "paid" | "cancelled"
      log_level: "info" | "warn" | "error"
      ota_job_status:
        | "pending"
        | "downloading"
        | "installed"
        | "restarted"
        | "ok"
        | "rollback"
      payment_provider:
        | "gpay"
        | "apple_demo"
        | "qr"
        | "emv"
        | "coins"
        | "panel_override"
        | "remote_link"
      payment_status: "pending" | "succeeded" | "failed"
      theme_scope: "initial_screen" | "default_ui"
      ticket_status: "active" | "expired" | "void"
      ui_scope: "initial_screen" | "default_ui"
      user_role: "admin" | "operator" | "inspector" | "device"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      alert_status: ["open", "closed"],
      alert_type: [
        "paper_low_20",
        "paper_low_10",
        "emv_off",
        "rssi_low",
        "temp_high",
        "power_issue",
      ],
      command_action: [
        "OPEN_PAYMENT_WITH_DURATION",
        "SET_A11Y_PROFILE",
        "SCREENSHOT",
        "PRINT_TEST",
        "REFRESH_TARIFFS",
        "RESTART_UI",
        "PING_EMV",
        "CHANGE_COMPANY",
        "PUSH_THEME",
      ],
      command_status: ["queued", "in_progress", "done", "error"],
      company_mode: ["local", "api_externa"],
      fine_status: ["active", "paid", "cancelled"],
      log_level: ["info", "warn", "error"],
      ota_job_status: [
        "pending",
        "downloading",
        "installed",
        "restarted",
        "ok",
        "rollback",
      ],
      payment_provider: [
        "gpay",
        "apple_demo",
        "qr",
        "emv",
        "coins",
        "panel_override",
        "remote_link",
      ],
      payment_status: ["pending", "succeeded", "failed"],
      theme_scope: ["initial_screen", "default_ui"],
      ticket_status: ["active", "expired", "void"],
      ui_scope: ["initial_screen", "default_ui"],
      user_role: ["admin", "operator", "inspector", "device"],
    },
  },
} as const
