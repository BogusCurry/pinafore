PGDMP     :                    v            mastodon_development    10.2    10.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    135202    mastodon_development    DATABASE     �   CREATE DATABASE mastodon_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 $   DROP DATABASE mastodon_development;
             nolan    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             nolan    false                        0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  nolan    false    3                        3079    12544    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                       0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    135203    timestamp_id(text)    FUNCTION     Y  CREATE FUNCTION timestamp_id(table_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
  DECLARE
    time_part bigint;
    sequence_base bigint;
    tail bigint;
  BEGIN
    time_part := (
      -- Get the time in milliseconds
      ((date_part('epoch', now()) * 1000))::bigint
      -- And shift it over two bytes
      << 16);

    sequence_base := (
      'x' ||
      -- Take the first two bytes (four hex characters)
      substr(
        -- Of the MD5 hash of the data we documented
        md5(table_name ||
          '69283236cfae0066ef13109248240c43' ||
          time_part::text
        ),
        1, 4
      )
    -- And turn it into a bigint
    )::bit(16)::bigint;

    -- Finally, add our sequence number to our base, and chop
    -- it to the last two bytes
    tail := (
      (sequence_base + nextval(table_name || '_id_seq'))
      & 65535);

    -- Return the time part and the sequence part. OR appears
    -- faster here than addition, but they're equivalent:
    -- time_part has no trailing two bytes, and tail is only
    -- the last two bytes.
    RETURN time_part | tail;
  END
$$;
 4   DROP FUNCTION public.timestamp_id(table_name text);
       public       nolan    false    1    3            �            1259    135204    account_domain_blocks    TABLE     �   CREATE TABLE account_domain_blocks (
    id bigint NOT NULL,
    domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
 )   DROP TABLE public.account_domain_blocks;
       public         nolan    false    3            �            1259    135210    account_domain_blocks_id_seq    SEQUENCE     ~   CREATE SEQUENCE account_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.account_domain_blocks_id_seq;
       public       nolan    false    3    196                       0    0    account_domain_blocks_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE account_domain_blocks_id_seq OWNED BY account_domain_blocks.id;
            public       nolan    false    197            �            1259    135212    account_moderation_notes    TABLE       CREATE TABLE account_moderation_notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 ,   DROP TABLE public.account_moderation_notes;
       public         nolan    false    3            �            1259    135218    account_moderation_notes_id_seq    SEQUENCE     �   CREATE SEQUENCE account_moderation_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.account_moderation_notes_id_seq;
       public       nolan    false    3    198                       0    0    account_moderation_notes_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE account_moderation_notes_id_seq OWNED BY account_moderation_notes.id;
            public       nolan    false    199            �            1259    135220    accounts    TABLE       CREATE TABLE accounts (
    id bigint NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    secret character varying DEFAULT ''::character varying NOT NULL,
    private_key text,
    public_key text DEFAULT ''::text NOT NULL,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    salmon_url character varying DEFAULT ''::character varying NOT NULL,
    hub_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    display_name character varying DEFAULT ''::character varying NOT NULL,
    uri character varying DEFAULT ''::character varying NOT NULL,
    url character varying,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    header_file_name character varying,
    header_content_type character varying,
    header_file_size integer,
    header_updated_at timestamp without time zone,
    avatar_remote_url character varying,
    subscription_expires_at timestamp without time zone,
    silenced boolean DEFAULT false NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    header_remote_url character varying DEFAULT ''::character varying NOT NULL,
    statuses_count integer DEFAULT 0 NOT NULL,
    followers_count integer DEFAULT 0 NOT NULL,
    following_count integer DEFAULT 0 NOT NULL,
    last_webfingered_at timestamp without time zone,
    inbox_url character varying DEFAULT ''::character varying NOT NULL,
    outbox_url character varying DEFAULT ''::character varying NOT NULL,
    shared_inbox_url character varying DEFAULT ''::character varying NOT NULL,
    followers_url character varying DEFAULT ''::character varying NOT NULL,
    protocol integer DEFAULT 0 NOT NULL,
    memorial boolean DEFAULT false NOT NULL,
    moved_to_account_id bigint
);
    DROP TABLE public.accounts;
       public         nolan    false    3            �            1259    135248    accounts_id_seq    SEQUENCE     q   CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accounts_id_seq;
       public       nolan    false    200    3                       0    0    accounts_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;
            public       nolan    false    201            �            1259    135250    admin_action_logs    TABLE     o  CREATE TABLE admin_action_logs (
    id bigint NOT NULL,
    account_id bigint,
    action character varying DEFAULT ''::character varying NOT NULL,
    target_type character varying,
    target_id bigint,
    recorded_changes text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 %   DROP TABLE public.admin_action_logs;
       public         nolan    false    3            �            1259    135258    admin_action_logs_id_seq    SEQUENCE     z   CREATE SEQUENCE admin_action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.admin_action_logs_id_seq;
       public       nolan    false    202    3                       0    0    admin_action_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE admin_action_logs_id_seq OWNED BY admin_action_logs.id;
            public       nolan    false    203            �            1259    135260    ar_internal_metadata    TABLE     �   CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         nolan    false    3            �            1259    135266    blocks    TABLE     �   CREATE TABLE blocks (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.blocks;
       public         nolan    false    3            �            1259    135269    blocks_id_seq    SEQUENCE     o   CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.blocks_id_seq;
       public       nolan    false    3    205                       0    0    blocks_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;
            public       nolan    false    206            �            1259    135271    conversation_mutes    TABLE     �   CREATE TABLE conversation_mutes (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL
);
 &   DROP TABLE public.conversation_mutes;
       public         nolan    false    3            �            1259    135274    conversation_mutes_id_seq    SEQUENCE     {   CREATE SEQUENCE conversation_mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.conversation_mutes_id_seq;
       public       nolan    false    207    3                       0    0    conversation_mutes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE conversation_mutes_id_seq OWNED BY conversation_mutes.id;
            public       nolan    false    208            �            1259    135276    conversations    TABLE     �   CREATE TABLE conversations (
    id bigint NOT NULL,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.conversations;
       public         nolan    false    3            �            1259    135282    conversations_id_seq    SEQUENCE     v   CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.conversations_id_seq;
       public       nolan    false    3    209                       0    0    conversations_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;
            public       nolan    false    210            �            1259    135284    custom_emojis    TABLE     L  CREATE TABLE custom_emojis (
    id bigint NOT NULL,
    shortcode character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    uri character varying,
    image_remote_url character varying,
    visible_in_picker boolean DEFAULT true NOT NULL
);
 !   DROP TABLE public.custom_emojis;
       public         nolan    false    3            �            1259    135293    custom_emojis_id_seq    SEQUENCE     v   CREATE SEQUENCE custom_emojis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.custom_emojis_id_seq;
       public       nolan    false    3    211            	           0    0    custom_emojis_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE custom_emojis_id_seq OWNED BY custom_emojis.id;
            public       nolan    false    212            �            1259    135295    domain_blocks    TABLE     7  CREATE TABLE domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    severity integer DEFAULT 0,
    reject_media boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.domain_blocks;
       public         nolan    false    3            �            1259    135304    domain_blocks_id_seq    SEQUENCE     v   CREATE SEQUENCE domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.domain_blocks_id_seq;
       public       nolan    false    213    3            
           0    0    domain_blocks_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE domain_blocks_id_seq OWNED BY domain_blocks.id;
            public       nolan    false    214            �            1259    135306    email_domain_blocks    TABLE     �   CREATE TABLE email_domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 '   DROP TABLE public.email_domain_blocks;
       public         nolan    false    3            �            1259    135313    email_domain_blocks_id_seq    SEQUENCE     |   CREATE SEQUENCE email_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.email_domain_blocks_id_seq;
       public       nolan    false    215    3                       0    0    email_domain_blocks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE email_domain_blocks_id_seq OWNED BY email_domain_blocks.id;
            public       nolan    false    216            �            1259    135315 
   favourites    TABLE     �   CREATE TABLE favourites (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL
);
    DROP TABLE public.favourites;
       public         nolan    false    3            �            1259    135318    favourites_id_seq    SEQUENCE     s   CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.favourites_id_seq;
       public       nolan    false    3    217                       0    0    favourites_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;
            public       nolan    false    218            �            1259    135320    follow_requests    TABLE       CREATE TABLE follow_requests (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
 #   DROP TABLE public.follow_requests;
       public         nolan    false    3            �            1259    135324    follow_requests_id_seq    SEQUENCE     x   CREATE SEQUENCE follow_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.follow_requests_id_seq;
       public       nolan    false    219    3                       0    0    follow_requests_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE follow_requests_id_seq OWNED BY follow_requests.id;
            public       nolan    false    220            �            1259    135326    follows    TABLE       CREATE TABLE follows (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
    DROP TABLE public.follows;
       public         nolan    false    3            �            1259    135330    follows_id_seq    SEQUENCE     p   CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.follows_id_seq;
       public       nolan    false    3    221                       0    0    follows_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE follows_id_seq OWNED BY follows.id;
            public       nolan    false    222            �            1259    135332    imports    TABLE     �  CREATE TABLE imports (
    id bigint NOT NULL,
    type integer NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data_file_name character varying,
    data_content_type character varying,
    data_file_size integer,
    data_updated_at timestamp without time zone,
    account_id bigint NOT NULL
);
    DROP TABLE public.imports;
       public         nolan    false    3            �            1259    135339    imports_id_seq    SEQUENCE     p   CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.imports_id_seq;
       public       nolan    false    3    223                       0    0    imports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE imports_id_seq OWNED BY imports.id;
            public       nolan    false    224            �            1259    135341    invites    TABLE     Y  CREATE TABLE invites (
    id bigint NOT NULL,
    user_id bigint,
    code character varying DEFAULT ''::character varying NOT NULL,
    expires_at timestamp without time zone,
    max_uses integer,
    uses integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.invites;
       public         nolan    false    3            �            1259    135349    invites_id_seq    SEQUENCE     p   CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.invites_id_seq;
       public       nolan    false    225    3                       0    0    invites_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE invites_id_seq OWNED BY invites.id;
            public       nolan    false    226            �            1259    135351    list_accounts    TABLE     �   CREATE TABLE list_accounts (
    id bigint NOT NULL,
    list_id bigint NOT NULL,
    account_id bigint NOT NULL,
    follow_id bigint NOT NULL
);
 !   DROP TABLE public.list_accounts;
       public         nolan    false    3            �            1259    135354    list_accounts_id_seq    SEQUENCE     v   CREATE SEQUENCE list_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.list_accounts_id_seq;
       public       nolan    false    3    227                       0    0    list_accounts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE list_accounts_id_seq OWNED BY list_accounts.id;
            public       nolan    false    228            �            1259    135356    lists    TABLE     �   CREATE TABLE lists (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.lists;
       public         nolan    false    3            �            1259    135363    lists_id_seq    SEQUENCE     n   CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lists_id_seq;
       public       nolan    false    3    229                       0    0    lists_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE lists_id_seq OWNED BY lists.id;
            public       nolan    false    230            �            1259    135365    media_attachments    TABLE     '  CREATE TABLE media_attachments (
    id bigint NOT NULL,
    status_id bigint,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shortcode character varying,
    type integer DEFAULT 0 NOT NULL,
    file_meta json,
    account_id bigint,
    description text
);
 %   DROP TABLE public.media_attachments;
       public         nolan    false    3            �            1259    135373    media_attachments_id_seq    SEQUENCE     z   CREATE SEQUENCE media_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.media_attachments_id_seq;
       public       nolan    false    3    231                       0    0    media_attachments_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE media_attachments_id_seq OWNED BY media_attachments.id;
            public       nolan    false    232            �            1259    135375    mentions    TABLE     �   CREATE TABLE mentions (
    id bigint NOT NULL,
    status_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
    DROP TABLE public.mentions;
       public         nolan    false    3            �            1259    135378    mentions_id_seq    SEQUENCE     q   CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.mentions_id_seq;
       public       nolan    false    3    233                       0    0    mentions_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;
            public       nolan    false    234            �            1259    135380    mutes    TABLE       CREATE TABLE mutes (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    hide_notifications boolean DEFAULT true NOT NULL
);
    DROP TABLE public.mutes;
       public         nolan    false    3            �            1259    135384    mutes_id_seq    SEQUENCE     n   CREATE SEQUENCE mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.mutes_id_seq;
       public       nolan    false    3    235                       0    0    mutes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE mutes_id_seq OWNED BY mutes.id;
            public       nolan    false    236            �            1259    135386    notifications    TABLE       CREATE TABLE notifications (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint,
    from_account_id bigint
);
 !   DROP TABLE public.notifications;
       public         nolan    false    3            �            1259    135392    notifications_id_seq    SEQUENCE     v   CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public       nolan    false    3    237                       0    0    notifications_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;
            public       nolan    false    238            �            1259    135394    oauth_access_grants    TABLE     n  CREATE TABLE oauth_access_grants (
    id bigint NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying,
    application_id bigint NOT NULL,
    resource_owner_id bigint NOT NULL
);
 '   DROP TABLE public.oauth_access_grants;
       public         nolan    false    3            �            1259    135400    oauth_access_grants_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_grants_id_seq;
       public       nolan    false    3    239                       0    0    oauth_access_grants_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;
            public       nolan    false    240            �            1259    135402    oauth_access_tokens    TABLE     X  CREATE TABLE oauth_access_tokens (
    id bigint NOT NULL,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying,
    application_id bigint,
    resource_owner_id bigint
);
 '   DROP TABLE public.oauth_access_tokens;
       public         nolan    false    3            �            1259    135408    oauth_access_tokens_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_tokens_id_seq;
       public       nolan    false    3    241                       0    0    oauth_access_tokens_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;
            public       nolan    false    242            �            1259    135410    oauth_applications    TABLE     �  CREATE TABLE oauth_applications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    superapp boolean DEFAULT false NOT NULL,
    website character varying,
    owner_type character varying,
    owner_id bigint
);
 &   DROP TABLE public.oauth_applications;
       public         nolan    false    3            �            1259    135418    oauth_applications_id_seq    SEQUENCE     {   CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.oauth_applications_id_seq;
       public       nolan    false    3    243                       0    0    oauth_applications_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;
            public       nolan    false    244            �            1259    135420    preview_cards    TABLE       CREATE TABLE preview_cards (
    id bigint NOT NULL,
    url character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    type integer DEFAULT 0 NOT NULL,
    html text DEFAULT ''::text NOT NULL,
    author_name character varying DEFAULT ''::character varying NOT NULL,
    author_url character varying DEFAULT ''::character varying NOT NULL,
    provider_name character varying DEFAULT ''::character varying NOT NULL,
    provider_url character varying DEFAULT ''::character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embed_url character varying DEFAULT ''::character varying NOT NULL
);
 !   DROP TABLE public.preview_cards;
       public         nolan    false    3            �            1259    135438    preview_cards_id_seq    SEQUENCE     v   CREATE SEQUENCE preview_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.preview_cards_id_seq;
       public       nolan    false    3    245                       0    0    preview_cards_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE preview_cards_id_seq OWNED BY preview_cards.id;
            public       nolan    false    246            �            1259    135440    preview_cards_statuses    TABLE     l   CREATE TABLE preview_cards_statuses (
    preview_card_id bigint NOT NULL,
    status_id bigint NOT NULL
);
 *   DROP TABLE public.preview_cards_statuses;
       public         nolan    false    3            �            1259    135443    reports    TABLE     �  CREATE TABLE reports (
    id bigint NOT NULL,
    status_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    action_taken boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    action_taken_by_account_id bigint,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.reports;
       public         nolan    false    3            �            1259    135452    reports_id_seq    SEQUENCE     p   CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reports_id_seq;
       public       nolan    false    3    248                       0    0    reports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE reports_id_seq OWNED BY reports.id;
            public       nolan    false    249            �            1259    135454    schema_migrations    TABLE     K   CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         nolan    false    3            �            1259    135460    session_activations    TABLE     �  CREATE TABLE session_activations (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_agent character varying DEFAULT ''::character varying NOT NULL,
    ip inet,
    access_token_id bigint,
    user_id bigint NOT NULL,
    web_push_subscription_id bigint
);
 '   DROP TABLE public.session_activations;
       public         nolan    false    3            �            1259    135467    session_activations_id_seq    SEQUENCE     |   CREATE SEQUENCE session_activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.session_activations_id_seq;
       public       nolan    false    251    3                       0    0    session_activations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE session_activations_id_seq OWNED BY session_activations.id;
            public       nolan    false    252            �            1259    135469    settings    TABLE     �   CREATE TABLE settings (
    id bigint NOT NULL,
    var character varying NOT NULL,
    value text,
    thing_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thing_id bigint
);
    DROP TABLE public.settings;
       public         nolan    false    3            �            1259    135475    settings_id_seq    SEQUENCE     q   CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public       nolan    false    3    253                       0    0    settings_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE settings_id_seq OWNED BY settings.id;
            public       nolan    false    254            �            1259    135477    site_uploads    TABLE     �  CREATE TABLE site_uploads (
    id bigint NOT NULL,
    var character varying DEFAULT ''::character varying NOT NULL,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    meta json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
     DROP TABLE public.site_uploads;
       public         nolan    false    3                        1259    135484    site_uploads_id_seq    SEQUENCE     u   CREATE SEQUENCE site_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.site_uploads_id_seq;
       public       nolan    false    3    255                       0    0    site_uploads_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE site_uploads_id_seq OWNED BY site_uploads.id;
            public       nolan    false    256                       1259    135486    status_pins    TABLE     �   CREATE TABLE status_pins (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.status_pins;
       public         nolan    false    3                       1259    135491    status_pins_id_seq    SEQUENCE     t   CREATE SEQUENCE status_pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.status_pins_id_seq;
       public       nolan    false    3    257                       0    0    status_pins_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE status_pins_id_seq OWNED BY status_pins.id;
            public       nolan    false    258                       1259    135493    statuses    TABLE       CREATE TABLE statuses (
    id bigint DEFAULT timestamp_id('statuses'::text) NOT NULL,
    uri character varying,
    text text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    in_reply_to_id bigint,
    reblog_of_id bigint,
    url character varying,
    sensitive boolean DEFAULT false NOT NULL,
    visibility integer DEFAULT 0 NOT NULL,
    spoiler_text text DEFAULT ''::text NOT NULL,
    reply boolean DEFAULT false NOT NULL,
    favourites_count integer DEFAULT 0 NOT NULL,
    reblogs_count integer DEFAULT 0 NOT NULL,
    language character varying,
    conversation_id bigint,
    local boolean,
    account_id bigint NOT NULL,
    application_id bigint,
    in_reply_to_account_id bigint
);
    DROP TABLE public.statuses;
       public         nolan    false    274    3                       1259    135507    statuses_id_seq    SEQUENCE     q   CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.statuses_id_seq;
       public       nolan    false    3                       1259    135509    statuses_tags    TABLE     Z   CREATE TABLE statuses_tags (
    status_id bigint NOT NULL,
    tag_id bigint NOT NULL
);
 !   DROP TABLE public.statuses_tags;
       public         nolan    false    3                       1259    135512    stream_entries    TABLE     !  CREATE TABLE stream_entries (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    account_id bigint
);
 "   DROP TABLE public.stream_entries;
       public         nolan    false    3                       1259    135519    stream_entries_id_seq    SEQUENCE     w   CREATE SEQUENCE stream_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.stream_entries_id_seq;
       public       nolan    false    3    262                        0    0    stream_entries_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE stream_entries_id_seq OWNED BY stream_entries.id;
            public       nolan    false    263                       1259    135521    subscriptions    TABLE     �  CREATE TABLE subscriptions (
    id bigint NOT NULL,
    callback_url character varying DEFAULT ''::character varying NOT NULL,
    secret character varying,
    expires_at timestamp without time zone,
    confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_successful_delivery_at timestamp without time zone,
    domain character varying,
    account_id bigint NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         nolan    false    3            	           1259    135529    subscriptions_id_seq    SEQUENCE     v   CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.subscriptions_id_seq;
       public       nolan    false    3    264            !           0    0    subscriptions_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;
            public       nolan    false    265            
           1259    135531    tags    TABLE     �   CREATE TABLE tags (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.tags;
       public         nolan    false    3                       1259    135538    tags_id_seq    SEQUENCE     m   CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tags_id_seq;
       public       nolan    false    3    266            "           0    0    tags_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE tags_id_seq OWNED BY tags.id;
            public       nolan    false    267                       1259    135540    users    TABLE     �  CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    admin boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    locale character varying,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    consumed_timestep integer,
    otp_required_for_login boolean DEFAULT false NOT NULL,
    last_emailed_at timestamp without time zone,
    otp_backup_codes character varying[],
    filtered_languages character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    account_id bigint NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    moderator boolean DEFAULT false NOT NULL,
    invite_id bigint
);
    DROP TABLE public.users;
       public         nolan    false    3                       1259    135554    users_id_seq    SEQUENCE     n   CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       nolan    false    3    268            #           0    0    users_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE users_id_seq OWNED BY users.id;
            public       nolan    false    269                       1259    135556    web_push_subscriptions    TABLE     6  CREATE TABLE web_push_subscriptions (
    id bigint NOT NULL,
    endpoint character varying NOT NULL,
    key_p256dh character varying NOT NULL,
    key_auth character varying NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 *   DROP TABLE public.web_push_subscriptions;
       public         nolan    false    3                       1259    135562    web_push_subscriptions_id_seq    SEQUENCE        CREATE SEQUENCE web_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.web_push_subscriptions_id_seq;
       public       nolan    false    3    270            $           0    0    web_push_subscriptions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE web_push_subscriptions_id_seq OWNED BY web_push_subscriptions.id;
            public       nolan    false    271                       1259    135564    web_settings    TABLE     �   CREATE TABLE web_settings (
    id bigint NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);
     DROP TABLE public.web_settings;
       public         nolan    false    3                       1259    135570    web_settings_id_seq    SEQUENCE     u   CREATE SEQUENCE web_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.web_settings_id_seq;
       public       nolan    false    272    3            %           0    0    web_settings_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE web_settings_id_seq OWNED BY web_settings.id;
            public       nolan    false    273            �	           2604    135572    account_domain_blocks id    DEFAULT     v   ALTER TABLE ONLY account_domain_blocks ALTER COLUMN id SET DEFAULT nextval('account_domain_blocks_id_seq'::regclass);
 G   ALTER TABLE public.account_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    197    196            �	           2604    135573    account_moderation_notes id    DEFAULT     |   ALTER TABLE ONLY account_moderation_notes ALTER COLUMN id SET DEFAULT nextval('account_moderation_notes_id_seq'::regclass);
 J   ALTER TABLE public.account_moderation_notes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    199    198            
           2604    135574    accounts id    DEFAULT     \   ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);
 :   ALTER TABLE public.accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    201    200            
           2604    135575    admin_action_logs id    DEFAULT     n   ALTER TABLE ONLY admin_action_logs ALTER COLUMN id SET DEFAULT nextval('admin_action_logs_id_seq'::regclass);
 C   ALTER TABLE public.admin_action_logs ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    203    202            
           2604    135576 	   blocks id    DEFAULT     X   ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);
 8   ALTER TABLE public.blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    206    205            
           2604    135577    conversation_mutes id    DEFAULT     p   ALTER TABLE ONLY conversation_mutes ALTER COLUMN id SET DEFAULT nextval('conversation_mutes_id_seq'::regclass);
 D   ALTER TABLE public.conversation_mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    208    207            
           2604    135578    conversations id    DEFAULT     f   ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);
 ?   ALTER TABLE public.conversations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    210    209            
           2604    135579    custom_emojis id    DEFAULT     f   ALTER TABLE ONLY custom_emojis ALTER COLUMN id SET DEFAULT nextval('custom_emojis_id_seq'::regclass);
 ?   ALTER TABLE public.custom_emojis ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    212    211            
           2604    135580    domain_blocks id    DEFAULT     f   ALTER TABLE ONLY domain_blocks ALTER COLUMN id SET DEFAULT nextval('domain_blocks_id_seq'::regclass);
 ?   ALTER TABLE public.domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    214    213             
           2604    135581    email_domain_blocks id    DEFAULT     r   ALTER TABLE ONLY email_domain_blocks ALTER COLUMN id SET DEFAULT nextval('email_domain_blocks_id_seq'::regclass);
 E   ALTER TABLE public.email_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    216    215            !
           2604    135582    favourites id    DEFAULT     `   ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);
 <   ALTER TABLE public.favourites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    218    217            #
           2604    135583    follow_requests id    DEFAULT     j   ALTER TABLE ONLY follow_requests ALTER COLUMN id SET DEFAULT nextval('follow_requests_id_seq'::regclass);
 A   ALTER TABLE public.follow_requests ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    220    219            %
           2604    135584 
   follows id    DEFAULT     Z   ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);
 9   ALTER TABLE public.follows ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    222    221            '
           2604    135585 
   imports id    DEFAULT     Z   ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);
 9   ALTER TABLE public.imports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    224    223            *
           2604    135586 
   invites id    DEFAULT     Z   ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);
 9   ALTER TABLE public.invites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    226    225            +
           2604    135587    list_accounts id    DEFAULT     f   ALTER TABLE ONLY list_accounts ALTER COLUMN id SET DEFAULT nextval('list_accounts_id_seq'::regclass);
 ?   ALTER TABLE public.list_accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    228    227            -
           2604    135588    lists id    DEFAULT     V   ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);
 7   ALTER TABLE public.lists ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    230    229            0
           2604    135589    media_attachments id    DEFAULT     n   ALTER TABLE ONLY media_attachments ALTER COLUMN id SET DEFAULT nextval('media_attachments_id_seq'::regclass);
 C   ALTER TABLE public.media_attachments ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    232    231            1
           2604    135590    mentions id    DEFAULT     \   ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);
 :   ALTER TABLE public.mentions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    234    233            3
           2604    135591    mutes id    DEFAULT     V   ALTER TABLE ONLY mutes ALTER COLUMN id SET DEFAULT nextval('mutes_id_seq'::regclass);
 7   ALTER TABLE public.mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    236    235            4
           2604    135592    notifications id    DEFAULT     f   ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    238    237            5
           2604    135593    oauth_access_grants id    DEFAULT     r   ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_grants ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    240    239            6
           2604    135594    oauth_access_tokens id    DEFAULT     r   ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_tokens ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    242    241            9
           2604    135595    oauth_applications id    DEFAULT     p   ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);
 D   ALTER TABLE public.oauth_applications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    244    243            F
           2604    135596    preview_cards id    DEFAULT     f   ALTER TABLE ONLY preview_cards ALTER COLUMN id SET DEFAULT nextval('preview_cards_id_seq'::regclass);
 ?   ALTER TABLE public.preview_cards ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    246    245            J
           2604    135597 
   reports id    DEFAULT     Z   ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);
 9   ALTER TABLE public.reports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    249    248            L
           2604    135598    session_activations id    DEFAULT     r   ALTER TABLE ONLY session_activations ALTER COLUMN id SET DEFAULT nextval('session_activations_id_seq'::regclass);
 E   ALTER TABLE public.session_activations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    252    251            M
           2604    135599    settings id    DEFAULT     \   ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    254    253            O
           2604    135600    site_uploads id    DEFAULT     d   ALTER TABLE ONLY site_uploads ALTER COLUMN id SET DEFAULT nextval('site_uploads_id_seq'::regclass);
 >   ALTER TABLE public.site_uploads ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    256    255            R
           2604    135601    status_pins id    DEFAULT     b   ALTER TABLE ONLY status_pins ALTER COLUMN id SET DEFAULT nextval('status_pins_id_seq'::regclass);
 =   ALTER TABLE public.status_pins ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    258    257            \
           2604    135602    stream_entries id    DEFAULT     h   ALTER TABLE ONLY stream_entries ALTER COLUMN id SET DEFAULT nextval('stream_entries_id_seq'::regclass);
 @   ALTER TABLE public.stream_entries ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    263    262            _
           2604    135603    subscriptions id    DEFAULT     f   ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);
 ?   ALTER TABLE public.subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    265    264            a
           2604    135604    tags id    DEFAULT     T   ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
 6   ALTER TABLE public.tags ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    267    266            j
           2604    135605    users id    DEFAULT     V   ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    269    268            k
           2604    135606    web_push_subscriptions id    DEFAULT     x   ALTER TABLE ONLY web_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('web_push_subscriptions_id_seq'::regclass);
 H   ALTER TABLE public.web_push_subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    271    270            l
           2604    135607    web_settings id    DEFAULT     d   ALTER TABLE ONLY web_settings ALTER COLUMN id SET DEFAULT nextval('web_settings_id_seq'::regclass);
 >   ALTER TABLE public.web_settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    273    272            �          0    135204    account_domain_blocks 
   TABLE DATA               X   COPY account_domain_blocks (id, domain, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    196    �      �          0    135212    account_moderation_notes 
   TABLE DATA               o   COPY account_moderation_notes (id, content, account_id, target_account_id, created_at, updated_at) FROM stdin;
    public       nolan    false    198   =�      �          0    135220    accounts 
   TABLE DATA               E  COPY accounts (id, username, domain, secret, private_key, public_key, remote_url, salmon_url, hub_url, created_at, updated_at, note, display_name, uri, url, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, header_file_name, header_content_type, header_file_size, header_updated_at, avatar_remote_url, subscription_expires_at, silenced, suspended, locked, header_remote_url, statuses_count, followers_count, following_count, last_webfingered_at, inbox_url, outbox_url, shared_inbox_url, followers_url, protocol, memorial, moved_to_account_id) FROM stdin;
    public       nolan    false    200   Z�      �          0    135250    admin_action_logs 
   TABLE DATA               ~   COPY admin_action_logs (id, account_id, action, target_type, target_id, recorded_changes, created_at, updated_at) FROM stdin;
    public       nolan    false    202   �      �          0    135260    ar_internal_metadata 
   TABLE DATA               K   COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       nolan    false    204   �      �          0    135266    blocks 
   TABLE DATA               T   COPY blocks (id, created_at, updated_at, account_id, target_account_id) FROM stdin;
    public       nolan    false    205         �          0    135271    conversation_mutes 
   TABLE DATA               F   COPY conversation_mutes (id, conversation_id, account_id) FROM stdin;
    public       nolan    false    207   <      �          0    135276    conversations 
   TABLE DATA               A   COPY conversations (id, uri, created_at, updated_at) FROM stdin;
    public       nolan    false    209   Y      �          0    135284    custom_emojis 
   TABLE DATA               �   COPY custom_emojis (id, shortcode, domain, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at, disabled, uri, image_remote_url, visible_in_picker) FROM stdin;
    public       nolan    false    211         �          0    135295    domain_blocks 
   TABLE DATA               \   COPY domain_blocks (id, domain, created_at, updated_at, severity, reject_media) FROM stdin;
    public       nolan    false    213   �      �          0    135306    email_domain_blocks 
   TABLE DATA               J   COPY email_domain_blocks (id, domain, created_at, updated_at) FROM stdin;
    public       nolan    false    215   �      �          0    135315 
   favourites 
   TABLE DATA               P   COPY favourites (id, created_at, updated_at, account_id, status_id) FROM stdin;
    public       nolan    false    217   �      �          0    135320    follow_requests 
   TABLE DATA               k   COPY follow_requests (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    219   �      �          0    135326    follows 
   TABLE DATA               c   COPY follows (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    221   �      �          0    135332    imports 
   TABLE DATA               �   COPY imports (id, type, approved, created_at, updated_at, data_file_name, data_content_type, data_file_size, data_updated_at, account_id) FROM stdin;
    public       nolan    false    223   `      �          0    135341    invites 
   TABLE DATA               a   COPY invites (id, user_id, code, expires_at, max_uses, uses, created_at, updated_at) FROM stdin;
    public       nolan    false    225   }      �          0    135351    list_accounts 
   TABLE DATA               D   COPY list_accounts (id, list_id, account_id, follow_id) FROM stdin;
    public       nolan    false    227   �      �          0    135356    lists 
   TABLE DATA               G   COPY lists (id, account_id, title, created_at, updated_at) FROM stdin;
    public       nolan    false    229   �      �          0    135365    media_attachments 
   TABLE DATA               �   COPY media_attachments (id, status_id, file_file_name, file_content_type, file_file_size, file_updated_at, remote_url, created_at, updated_at, shortcode, type, file_meta, account_id, description) FROM stdin;
    public       nolan    false    231   �      �          0    135375    mentions 
   TABLE DATA               N   COPY mentions (id, status_id, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    233   �      �          0    135380    mutes 
   TABLE DATA               g   COPY mutes (id, created_at, updated_at, account_id, target_account_id, hide_notifications) FROM stdin;
    public       nolan    false    235   M      �          0    135386    notifications 
   TABLE DATA               u   COPY notifications (id, activity_id, activity_type, created_at, updated_at, account_id, from_account_id) FROM stdin;
    public       nolan    false    237   j      �          0    135394    oauth_access_grants 
   TABLE DATA               �   COPY oauth_access_grants (id, token, expires_in, redirect_uri, created_at, revoked_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    239   '      �          0    135402    oauth_access_tokens 
   TABLE DATA               �   COPY oauth_access_tokens (id, token, refresh_token, expires_in, revoked_at, created_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    241   �F      �          0    135410    oauth_applications 
   TABLE DATA               �   COPY oauth_applications (id, name, uid, secret, redirect_uri, scopes, created_at, updated_at, superapp, website, owner_type, owner_id) FROM stdin;
    public       nolan    false    243   �m      �          0    135420    preview_cards 
   TABLE DATA               �   COPY preview_cards (id, url, title, description, image_file_name, image_content_type, image_file_size, image_updated_at, type, html, author_name, author_url, provider_name, provider_url, width, height, created_at, updated_at, embed_url) FROM stdin;
    public       nolan    false    245   ��      �          0    135440    preview_cards_statuses 
   TABLE DATA               E   COPY preview_cards_statuses (preview_card_id, status_id) FROM stdin;
    public       nolan    false    247   r�      �          0    135443    reports 
   TABLE DATA               �   COPY reports (id, status_ids, comment, action_taken, created_at, updated_at, account_id, action_taken_by_account_id, target_account_id) FROM stdin;
    public       nolan    false    248   ��      �          0    135454    schema_migrations 
   TABLE DATA               -   COPY schema_migrations (version) FROM stdin;
    public       nolan    false    250   ��      �          0    135460    session_activations 
   TABLE DATA               �   COPY session_activations (id, session_id, created_at, updated_at, user_agent, ip, access_token_id, user_id, web_push_subscription_id) FROM stdin;
    public       nolan    false    251   ��      �          0    135469    settings 
   TABLE DATA               Y   COPY settings (id, var, value, thing_type, created_at, updated_at, thing_id) FROM stdin;
    public       nolan    false    253   ��      �          0    135477    site_uploads 
   TABLE DATA               �   COPY site_uploads (id, var, file_file_name, file_content_type, file_file_size, file_updated_at, meta, created_at, updated_at) FROM stdin;
    public       nolan    false    255   ��      �          0    135486    status_pins 
   TABLE DATA               Q   COPY status_pins (id, account_id, status_id, created_at, updated_at) FROM stdin;
    public       nolan    false    257   �      �          0    135493    statuses 
   TABLE DATA                 COPY statuses (id, uri, text, created_at, updated_at, in_reply_to_id, reblog_of_id, url, sensitive, visibility, spoiler_text, reply, favourites_count, reblogs_count, language, conversation_id, local, account_id, application_id, in_reply_to_account_id) FROM stdin;
    public       nolan    false    259   |�      �          0    135509    statuses_tags 
   TABLE DATA               3   COPY statuses_tags (status_id, tag_id) FROM stdin;
    public       nolan    false    261   ,�      �          0    135512    stream_entries 
   TABLE DATA               m   COPY stream_entries (id, activity_id, activity_type, created_at, updated_at, hidden, account_id) FROM stdin;
    public       nolan    false    262   b�      �          0    135521    subscriptions 
   TABLE DATA               �   COPY subscriptions (id, callback_url, secret, expires_at, confirmed, created_at, updated_at, last_successful_delivery_at, domain, account_id) FROM stdin;
    public       nolan    false    264   	�      �          0    135531    tags 
   TABLE DATA               9   COPY tags (id, name, created_at, updated_at) FROM stdin;
    public       nolan    false    266   &�      �          0    135540    users 
   TABLE DATA                 COPY users (id, email, created_at, updated_at, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, admin, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, locale, encrypted_otp_secret, encrypted_otp_secret_iv, encrypted_otp_secret_salt, consumed_timestep, otp_required_for_login, last_emailed_at, otp_backup_codes, filtered_languages, account_id, disabled, moderator, invite_id) FROM stdin;
    public       nolan    false    268   y�      �          0    135556    web_push_subscriptions 
   TABLE DATA               k   COPY web_push_subscriptions (id, endpoint, key_p256dh, key_auth, data, created_at, updated_at) FROM stdin;
    public       nolan    false    270   ��      �          0    135564    web_settings 
   TABLE DATA               J   COPY web_settings (id, data, created_at, updated_at, user_id) FROM stdin;
    public       nolan    false    272   �      &           0    0    account_domain_blocks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('account_domain_blocks_id_seq', 1, false);
            public       nolan    false    197            '           0    0    account_moderation_notes_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('account_moderation_notes_id_seq', 1, false);
            public       nolan    false    199            (           0    0    accounts_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('accounts_id_seq', 4, true);
            public       nolan    false    201            )           0    0    admin_action_logs_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('admin_action_logs_id_seq', 4, true);
            public       nolan    false    203            *           0    0    blocks_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('blocks_id_seq', 1, false);
            public       nolan    false    206            +           0    0    conversation_mutes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('conversation_mutes_id_seq', 1, false);
            public       nolan    false    208            ,           0    0    conversations_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('conversations_id_seq', 55, true);
            public       nolan    false    210            -           0    0    custom_emojis_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('custom_emojis_id_seq', 3, true);
            public       nolan    false    212            .           0    0    domain_blocks_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('domain_blocks_id_seq', 1, false);
            public       nolan    false    214            /           0    0    email_domain_blocks_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('email_domain_blocks_id_seq', 1, false);
            public       nolan    false    216            0           0    0    favourites_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('favourites_id_seq', 7, true);
            public       nolan    false    218            1           0    0    follow_requests_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('follow_requests_id_seq', 1, false);
            public       nolan    false    220            2           0    0    follows_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('follows_id_seq', 6, true);
            public       nolan    false    222            3           0    0    imports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('imports_id_seq', 1, false);
            public       nolan    false    224            4           0    0    invites_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('invites_id_seq', 1, false);
            public       nolan    false    226            5           0    0    list_accounts_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('list_accounts_id_seq', 1, false);
            public       nolan    false    228            6           0    0    lists_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('lists_id_seq', 1, false);
            public       nolan    false    230            7           0    0    media_attachments_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('media_attachments_id_seq', 9, true);
            public       nolan    false    232            8           0    0    mentions_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('mentions_id_seq', 8, true);
            public       nolan    false    234            9           0    0    mutes_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('mutes_id_seq', 1, false);
            public       nolan    false    236            :           0    0    notifications_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('notifications_id_seq', 23, true);
            public       nolan    false    238            ;           0    0    oauth_access_grants_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_grants_id_seq', 169, true);
            public       nolan    false    240            <           0    0    oauth_access_tokens_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_tokens_id_seq', 362, true);
            public       nolan    false    242            =           0    0    oauth_applications_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('oauth_applications_id_seq', 210, true);
            public       nolan    false    244            >           0    0    preview_cards_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('preview_cards_id_seq', 1, true);
            public       nolan    false    246            ?           0    0    reports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('reports_id_seq', 1, false);
            public       nolan    false    249            @           0    0    session_activations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('session_activations_id_seq', 197, true);
            public       nolan    false    252            A           0    0    settings_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('settings_id_seq', 1, false);
            public       nolan    false    254            B           0    0    site_uploads_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('site_uploads_id_seq', 1, false);
            public       nolan    false    256            C           0    0    status_pins_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('status_pins_id_seq', 3, true);
            public       nolan    false    258            D           0    0    statuses_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('statuses_id_seq', 81, true);
            public       nolan    false    260            E           0    0    stream_entries_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('stream_entries_id_seq', 81, true);
            public       nolan    false    263            F           0    0    subscriptions_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('subscriptions_id_seq', 1, false);
            public       nolan    false    265            G           0    0    tags_id_seq    SEQUENCE SET     2   SELECT pg_catalog.setval('tags_id_seq', 2, true);
            public       nolan    false    267            H           0    0    users_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('users_id_seq', 4, true);
            public       nolan    false    269            I           0    0    web_push_subscriptions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('web_push_subscriptions_id_seq', 1, false);
            public       nolan    false    271            J           0    0    web_settings_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('web_settings_id_seq', 4, true);
            public       nolan    false    273            n
           2606    135612 0   account_domain_blocks account_domain_blocks_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT account_domain_blocks_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT account_domain_blocks_pkey;
       public         nolan    false    196            q
           2606    135614 6   account_moderation_notes account_moderation_notes_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT account_moderation_notes_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT account_moderation_notes_pkey;
       public         nolan    false    198            u
           2606    135616    accounts accounts_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
       public         nolan    false    200            |
           2606    135618 (   admin_action_logs admin_action_logs_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT admin_action_logs_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT admin_action_logs_pkey;
       public         nolan    false    202            �
           2606    135620 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         nolan    false    204            �
           2606    135622    blocks blocks_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.blocks DROP CONSTRAINT blocks_pkey;
       public         nolan    false    205            �
           2606    135624 *   conversation_mutes conversation_mutes_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT conversation_mutes_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT conversation_mutes_pkey;
       public         nolan    false    207            �
           2606    135626     conversations conversations_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_pkey;
       public         nolan    false    209            �
           2606    135628     custom_emojis custom_emojis_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY custom_emojis
    ADD CONSTRAINT custom_emojis_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.custom_emojis DROP CONSTRAINT custom_emojis_pkey;
       public         nolan    false    211            �
           2606    135630     domain_blocks domain_blocks_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY domain_blocks
    ADD CONSTRAINT domain_blocks_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.domain_blocks DROP CONSTRAINT domain_blocks_pkey;
       public         nolan    false    213            �
           2606    135632 ,   email_domain_blocks email_domain_blocks_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY email_domain_blocks
    ADD CONSTRAINT email_domain_blocks_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.email_domain_blocks DROP CONSTRAINT email_domain_blocks_pkey;
       public         nolan    false    215            �
           2606    135634    favourites favourites_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.favourites DROP CONSTRAINT favourites_pkey;
       public         nolan    false    217            �
           2606    135636 $   follow_requests follow_requests_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT follow_requests_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT follow_requests_pkey;
       public         nolan    false    219            �
           2606    135638    follows follows_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.follows DROP CONSTRAINT follows_pkey;
       public         nolan    false    221            �
           2606    135640    imports imports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.imports DROP CONSTRAINT imports_pkey;
       public         nolan    false    223            �
           2606    135642    invites invites_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.invites DROP CONSTRAINT invites_pkey;
       public         nolan    false    225            �
           2606    135644     list_accounts list_accounts_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT list_accounts_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT list_accounts_pkey;
       public         nolan    false    227            �
           2606    135646    lists lists_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_pkey;
       public         nolan    false    229            �
           2606    135648 (   media_attachments media_attachments_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT media_attachments_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT media_attachments_pkey;
       public         nolan    false    231            �
           2606    135650    mentions mentions_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT mentions_pkey;
       public         nolan    false    233            �
           2606    135652    mutes mutes_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY mutes
    ADD CONSTRAINT mutes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.mutes DROP CONSTRAINT mutes_pkey;
       public         nolan    false    235            �
           2606    135654     notifications notifications_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_pkey;
       public         nolan    false    237            �
           2606    135656 ,   oauth_access_grants oauth_access_grants_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT oauth_access_grants_pkey;
       public         nolan    false    239            �
           2606    135658 ,   oauth_access_tokens oauth_access_tokens_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT oauth_access_tokens_pkey;
       public         nolan    false    241            �
           2606    135660 *   oauth_applications oauth_applications_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT oauth_applications_pkey;
       public         nolan    false    243            �
           2606    135662     preview_cards preview_cards_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY preview_cards
    ADD CONSTRAINT preview_cards_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.preview_cards DROP CONSTRAINT preview_cards_pkey;
       public         nolan    false    245            �
           2606    135664    reports reports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
       public         nolan    false    248            �
           2606    135666 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         nolan    false    250            �
           2606    135668 ,   session_activations session_activations_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT session_activations_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT session_activations_pkey;
       public         nolan    false    251            �
           2606    135670    settings settings_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pkey;
       public         nolan    false    253            �
           2606    135672    site_uploads site_uploads_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY site_uploads
    ADD CONSTRAINT site_uploads_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.site_uploads DROP CONSTRAINT site_uploads_pkey;
       public         nolan    false    255            �
           2606    135674    status_pins status_pins_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT status_pins_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT status_pins_pkey;
       public         nolan    false    257            �
           2606    135676    statuses statuses_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT statuses_pkey;
       public         nolan    false    259            �
           2606    135678 "   stream_entries stream_entries_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT stream_entries_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT stream_entries_pkey;
       public         nolan    false    262            �
           2606    135680     subscriptions subscriptions_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public         nolan    false    264            �
           2606    135682    tags tags_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public         nolan    false    266            �
           2606    135684    users users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         nolan    false    268            �
           2606    135686 2   web_push_subscriptions web_push_subscriptions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY web_push_subscriptions
    ADD CONSTRAINT web_push_subscriptions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.web_push_subscriptions DROP CONSTRAINT web_push_subscriptions_pkey;
       public         nolan    false    270            �
           2606    135688    web_settings web_settings_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT web_settings_pkey;
       public         nolan    false    272            �
           1259    135689    account_activity    INDEX     l   CREATE UNIQUE INDEX account_activity ON notifications USING btree (account_id, activity_id, activity_type);
 $   DROP INDEX public.account_activity;
       public         nolan    false    237    237    237            �
           1259    135690    hashtag_search_index    INDEX     ^   CREATE INDEX hashtag_search_index ON tags USING btree (lower((name)::text) text_pattern_ops);
 (   DROP INDEX public.hashtag_search_index;
       public         nolan    false    266    266            o
           1259    135691 4   index_account_domain_blocks_on_account_id_and_domain    INDEX     �   CREATE UNIQUE INDEX index_account_domain_blocks_on_account_id_and_domain ON account_domain_blocks USING btree (account_id, domain);
 H   DROP INDEX public.index_account_domain_blocks_on_account_id_and_domain;
       public         nolan    false    196    196            r
           1259    135692 ,   index_account_moderation_notes_on_account_id    INDEX     p   CREATE INDEX index_account_moderation_notes_on_account_id ON account_moderation_notes USING btree (account_id);
 @   DROP INDEX public.index_account_moderation_notes_on_account_id;
       public         nolan    false    198            s
           1259    135693 3   index_account_moderation_notes_on_target_account_id    INDEX     ~   CREATE INDEX index_account_moderation_notes_on_target_account_id ON account_moderation_notes USING btree (target_account_id);
 G   DROP INDEX public.index_account_moderation_notes_on_target_account_id;
       public         nolan    false    198            v
           1259    135694    index_accounts_on_uri    INDEX     B   CREATE INDEX index_accounts_on_uri ON accounts USING btree (uri);
 )   DROP INDEX public.index_accounts_on_uri;
       public         nolan    false    200            w
           1259    135695    index_accounts_on_url    INDEX     B   CREATE INDEX index_accounts_on_url ON accounts USING btree (url);
 )   DROP INDEX public.index_accounts_on_url;
       public         nolan    false    200            x
           1259    135696 %   index_accounts_on_username_and_domain    INDEX     f   CREATE UNIQUE INDEX index_accounts_on_username_and_domain ON accounts USING btree (username, domain);
 9   DROP INDEX public.index_accounts_on_username_and_domain;
       public         nolan    false    200    200            y
           1259    135697 +   index_accounts_on_username_and_domain_lower    INDEX     �   CREATE INDEX index_accounts_on_username_and_domain_lower ON accounts USING btree (lower((username)::text), lower((domain)::text));
 ?   DROP INDEX public.index_accounts_on_username_and_domain_lower;
       public         nolan    false    200    200    200            }
           1259    135698 %   index_admin_action_logs_on_account_id    INDEX     b   CREATE INDEX index_admin_action_logs_on_account_id ON admin_action_logs USING btree (account_id);
 9   DROP INDEX public.index_admin_action_logs_on_account_id;
       public         nolan    false    202            ~
           1259    135699 4   index_admin_action_logs_on_target_type_and_target_id    INDEX     }   CREATE INDEX index_admin_action_logs_on_target_type_and_target_id ON admin_action_logs USING btree (target_type, target_id);
 H   DROP INDEX public.index_admin_action_logs_on_target_type_and_target_id;
       public         nolan    false    202    202            �
           1259    135700 0   index_blocks_on_account_id_and_target_account_id    INDEX     |   CREATE UNIQUE INDEX index_blocks_on_account_id_and_target_account_id ON blocks USING btree (account_id, target_account_id);
 D   DROP INDEX public.index_blocks_on_account_id_and_target_account_id;
       public         nolan    false    205    205            �
           1259    135701 :   index_conversation_mutes_on_account_id_and_conversation_id    INDEX     �   CREATE UNIQUE INDEX index_conversation_mutes_on_account_id_and_conversation_id ON conversation_mutes USING btree (account_id, conversation_id);
 N   DROP INDEX public.index_conversation_mutes_on_account_id_and_conversation_id;
       public         nolan    false    207    207            �
           1259    135702    index_conversations_on_uri    INDEX     S   CREATE UNIQUE INDEX index_conversations_on_uri ON conversations USING btree (uri);
 .   DROP INDEX public.index_conversations_on_uri;
       public         nolan    false    209            �
           1259    135703 +   index_custom_emojis_on_shortcode_and_domain    INDEX     r   CREATE UNIQUE INDEX index_custom_emojis_on_shortcode_and_domain ON custom_emojis USING btree (shortcode, domain);
 ?   DROP INDEX public.index_custom_emojis_on_shortcode_and_domain;
       public         nolan    false    211    211            �
           1259    135704    index_domain_blocks_on_domain    INDEX     Y   CREATE UNIQUE INDEX index_domain_blocks_on_domain ON domain_blocks USING btree (domain);
 1   DROP INDEX public.index_domain_blocks_on_domain;
       public         nolan    false    213            �
           1259    135705 #   index_email_domain_blocks_on_domain    INDEX     e   CREATE UNIQUE INDEX index_email_domain_blocks_on_domain ON email_domain_blocks USING btree (domain);
 7   DROP INDEX public.index_email_domain_blocks_on_domain;
       public         nolan    false    215            �
           1259    135706 %   index_favourites_on_account_id_and_id    INDEX     _   CREATE INDEX index_favourites_on_account_id_and_id ON favourites USING btree (account_id, id);
 9   DROP INDEX public.index_favourites_on_account_id_and_id;
       public         nolan    false    217    217            �
           1259    135707 ,   index_favourites_on_account_id_and_status_id    INDEX     t   CREATE UNIQUE INDEX index_favourites_on_account_id_and_status_id ON favourites USING btree (account_id, status_id);
 @   DROP INDEX public.index_favourites_on_account_id_and_status_id;
       public         nolan    false    217    217            �
           1259    135708    index_favourites_on_status_id    INDEX     R   CREATE INDEX index_favourites_on_status_id ON favourites USING btree (status_id);
 1   DROP INDEX public.index_favourites_on_status_id;
       public         nolan    false    217            �
           1259    135709 9   index_follow_requests_on_account_id_and_target_account_id    INDEX     �   CREATE UNIQUE INDEX index_follow_requests_on_account_id_and_target_account_id ON follow_requests USING btree (account_id, target_account_id);
 M   DROP INDEX public.index_follow_requests_on_account_id_and_target_account_id;
       public         nolan    false    219    219            �
           1259    135710 1   index_follows_on_account_id_and_target_account_id    INDEX     ~   CREATE UNIQUE INDEX index_follows_on_account_id_and_target_account_id ON follows USING btree (account_id, target_account_id);
 E   DROP INDEX public.index_follows_on_account_id_and_target_account_id;
       public         nolan    false    221    221            �
           1259    135711    index_invites_on_code    INDEX     I   CREATE UNIQUE INDEX index_invites_on_code ON invites USING btree (code);
 )   DROP INDEX public.index_invites_on_code;
       public         nolan    false    225            �
           1259    135712    index_invites_on_user_id    INDEX     H   CREATE INDEX index_invites_on_user_id ON invites USING btree (user_id);
 ,   DROP INDEX public.index_invites_on_user_id;
       public         nolan    false    225            �
           1259    135713 -   index_list_accounts_on_account_id_and_list_id    INDEX     v   CREATE UNIQUE INDEX index_list_accounts_on_account_id_and_list_id ON list_accounts USING btree (account_id, list_id);
 A   DROP INDEX public.index_list_accounts_on_account_id_and_list_id;
       public         nolan    false    227    227            �
           1259    135714     index_list_accounts_on_follow_id    INDEX     X   CREATE INDEX index_list_accounts_on_follow_id ON list_accounts USING btree (follow_id);
 4   DROP INDEX public.index_list_accounts_on_follow_id;
       public         nolan    false    227            �
           1259    135715 -   index_list_accounts_on_list_id_and_account_id    INDEX     o   CREATE INDEX index_list_accounts_on_list_id_and_account_id ON list_accounts USING btree (list_id, account_id);
 A   DROP INDEX public.index_list_accounts_on_list_id_and_account_id;
       public         nolan    false    227    227            �
           1259    135716    index_lists_on_account_id    INDEX     J   CREATE INDEX index_lists_on_account_id ON lists USING btree (account_id);
 -   DROP INDEX public.index_lists_on_account_id;
       public         nolan    false    229            �
           1259    135717 %   index_media_attachments_on_account_id    INDEX     b   CREATE INDEX index_media_attachments_on_account_id ON media_attachments USING btree (account_id);
 9   DROP INDEX public.index_media_attachments_on_account_id;
       public         nolan    false    231            �
           1259    135718 $   index_media_attachments_on_shortcode    INDEX     g   CREATE UNIQUE INDEX index_media_attachments_on_shortcode ON media_attachments USING btree (shortcode);
 8   DROP INDEX public.index_media_attachments_on_shortcode;
       public         nolan    false    231            �
           1259    135719 $   index_media_attachments_on_status_id    INDEX     `   CREATE INDEX index_media_attachments_on_status_id ON media_attachments USING btree (status_id);
 8   DROP INDEX public.index_media_attachments_on_status_id;
       public         nolan    false    231            �
           1259    135720 *   index_mentions_on_account_id_and_status_id    INDEX     p   CREATE UNIQUE INDEX index_mentions_on_account_id_and_status_id ON mentions USING btree (account_id, status_id);
 >   DROP INDEX public.index_mentions_on_account_id_and_status_id;
       public         nolan    false    233    233            �
           1259    135721    index_mentions_on_status_id    INDEX     N   CREATE INDEX index_mentions_on_status_id ON mentions USING btree (status_id);
 /   DROP INDEX public.index_mentions_on_status_id;
       public         nolan    false    233            �
           1259    135722 /   index_mutes_on_account_id_and_target_account_id    INDEX     z   CREATE UNIQUE INDEX index_mutes_on_account_id_and_target_account_id ON mutes USING btree (account_id, target_account_id);
 C   DROP INDEX public.index_mutes_on_account_id_and_target_account_id;
       public         nolan    false    235    235            �
           1259    135723 (   index_notifications_on_account_id_and_id    INDEX     j   CREATE INDEX index_notifications_on_account_id_and_id ON notifications USING btree (account_id, id DESC);
 <   DROP INDEX public.index_notifications_on_account_id_and_id;
       public         nolan    false    237    237            �
           1259    135724 4   index_notifications_on_activity_id_and_activity_type    INDEX     }   CREATE INDEX index_notifications_on_activity_id_and_activity_type ON notifications USING btree (activity_id, activity_type);
 H   DROP INDEX public.index_notifications_on_activity_id_and_activity_type;
       public         nolan    false    237    237            �
           1259    135725 "   index_oauth_access_grants_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);
 6   DROP INDEX public.index_oauth_access_grants_on_token;
       public         nolan    false    239            �
           1259    135726 *   index_oauth_access_tokens_on_refresh_token    INDEX     s   CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);
 >   DROP INDEX public.index_oauth_access_tokens_on_refresh_token;
       public         nolan    false    241            �
           1259    135727 .   index_oauth_access_tokens_on_resource_owner_id    INDEX     t   CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);
 B   DROP INDEX public.index_oauth_access_tokens_on_resource_owner_id;
       public         nolan    false    241            �
           1259    135728 "   index_oauth_access_tokens_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);
 6   DROP INDEX public.index_oauth_access_tokens_on_token;
       public         nolan    false    241            �
           1259    135729 3   index_oauth_applications_on_owner_id_and_owner_type    INDEX     {   CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON oauth_applications USING btree (owner_id, owner_type);
 G   DROP INDEX public.index_oauth_applications_on_owner_id_and_owner_type;
       public         nolan    false    243    243            �
           1259    135730    index_oauth_applications_on_uid    INDEX     ]   CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);
 3   DROP INDEX public.index_oauth_applications_on_uid;
       public         nolan    false    243            �
           1259    135731    index_preview_cards_on_url    INDEX     S   CREATE UNIQUE INDEX index_preview_cards_on_url ON preview_cards USING btree (url);
 .   DROP INDEX public.index_preview_cards_on_url;
       public         nolan    false    245            �
           1259    135732 =   index_preview_cards_statuses_on_status_id_and_preview_card_id    INDEX     �   CREATE INDEX index_preview_cards_statuses_on_status_id_and_preview_card_id ON preview_cards_statuses USING btree (status_id, preview_card_id);
 Q   DROP INDEX public.index_preview_cards_statuses_on_status_id_and_preview_card_id;
       public         nolan    false    247    247            �
           1259    135733    index_reports_on_account_id    INDEX     N   CREATE INDEX index_reports_on_account_id ON reports USING btree (account_id);
 /   DROP INDEX public.index_reports_on_account_id;
       public         nolan    false    248            �
           1259    135734 "   index_reports_on_target_account_id    INDEX     \   CREATE INDEX index_reports_on_target_account_id ON reports USING btree (target_account_id);
 6   DROP INDEX public.index_reports_on_target_account_id;
       public         nolan    false    248            �
           1259    135735 '   index_session_activations_on_session_id    INDEX     m   CREATE UNIQUE INDEX index_session_activations_on_session_id ON session_activations USING btree (session_id);
 ;   DROP INDEX public.index_session_activations_on_session_id;
       public         nolan    false    251            �
           1259    135736 $   index_session_activations_on_user_id    INDEX     `   CREATE INDEX index_session_activations_on_user_id ON session_activations USING btree (user_id);
 8   DROP INDEX public.index_session_activations_on_user_id;
       public         nolan    false    251            �
           1259    135737 1   index_settings_on_thing_type_and_thing_id_and_var    INDEX     {   CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);
 E   DROP INDEX public.index_settings_on_thing_type_and_thing_id_and_var;
       public         nolan    false    253    253    253            �
           1259    135738    index_site_uploads_on_var    INDEX     Q   CREATE UNIQUE INDEX index_site_uploads_on_var ON site_uploads USING btree (var);
 -   DROP INDEX public.index_site_uploads_on_var;
       public         nolan    false    255            �
           1259    135739 -   index_status_pins_on_account_id_and_status_id    INDEX     v   CREATE UNIQUE INDEX index_status_pins_on_account_id_and_status_id ON status_pins USING btree (account_id, status_id);
 A   DROP INDEX public.index_status_pins_on_account_id_and_status_id;
       public         nolan    false    257    257            �
           1259    135740    index_statuses_20180106    INDEX     l   CREATE INDEX index_statuses_20180106 ON statuses USING btree (account_id, id DESC, visibility, updated_at);
 +   DROP INDEX public.index_statuses_20180106;
       public         nolan    false    259    259    259    259            �
           1259    135741 !   index_statuses_on_conversation_id    INDEX     Z   CREATE INDEX index_statuses_on_conversation_id ON statuses USING btree (conversation_id);
 5   DROP INDEX public.index_statuses_on_conversation_id;
       public         nolan    false    259            �
           1259    135742     index_statuses_on_in_reply_to_id    INDEX     X   CREATE INDEX index_statuses_on_in_reply_to_id ON statuses USING btree (in_reply_to_id);
 4   DROP INDEX public.index_statuses_on_in_reply_to_id;
       public         nolan    false    259            �
           1259    135743 -   index_statuses_on_reblog_of_id_and_account_id    INDEX     o   CREATE INDEX index_statuses_on_reblog_of_id_and_account_id ON statuses USING btree (reblog_of_id, account_id);
 A   DROP INDEX public.index_statuses_on_reblog_of_id_and_account_id;
       public         nolan    false    259    259            �
           1259    135744    index_statuses_on_uri    INDEX     I   CREATE UNIQUE INDEX index_statuses_on_uri ON statuses USING btree (uri);
 )   DROP INDEX public.index_statuses_on_uri;
       public         nolan    false    259            �
           1259    135745     index_statuses_tags_on_status_id    INDEX     X   CREATE INDEX index_statuses_tags_on_status_id ON statuses_tags USING btree (status_id);
 4   DROP INDEX public.index_statuses_tags_on_status_id;
       public         nolan    false    261            �
           1259    135746 +   index_statuses_tags_on_tag_id_and_status_id    INDEX     r   CREATE UNIQUE INDEX index_statuses_tags_on_tag_id_and_status_id ON statuses_tags USING btree (tag_id, status_id);
 ?   DROP INDEX public.index_statuses_tags_on_tag_id_and_status_id;
       public         nolan    false    261    261            �
           1259    135747 ;   index_stream_entries_on_account_id_and_activity_type_and_id    INDEX     �   CREATE INDEX index_stream_entries_on_account_id_and_activity_type_and_id ON stream_entries USING btree (account_id, activity_type, id);
 O   DROP INDEX public.index_stream_entries_on_account_id_and_activity_type_and_id;
       public         nolan    false    262    262    262            �
           1259    135748 5   index_stream_entries_on_activity_id_and_activity_type    INDEX        CREATE INDEX index_stream_entries_on_activity_id_and_activity_type ON stream_entries USING btree (activity_id, activity_type);
 I   DROP INDEX public.index_stream_entries_on_activity_id_and_activity_type;
       public         nolan    false    262    262            �
           1259    135749 2   index_subscriptions_on_account_id_and_callback_url    INDEX     �   CREATE UNIQUE INDEX index_subscriptions_on_account_id_and_callback_url ON subscriptions USING btree (account_id, callback_url);
 F   DROP INDEX public.index_subscriptions_on_account_id_and_callback_url;
       public         nolan    false    264    264            �
           1259    135750    index_tags_on_name    INDEX     C   CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);
 &   DROP INDEX public.index_tags_on_name;
       public         nolan    false    266            �
           1259    135751    index_users_on_account_id    INDEX     J   CREATE INDEX index_users_on_account_id ON users USING btree (account_id);
 -   DROP INDEX public.index_users_on_account_id;
       public         nolan    false    268            �
           1259    135752 !   index_users_on_confirmation_token    INDEX     a   CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);
 5   DROP INDEX public.index_users_on_confirmation_token;
       public         nolan    false    268            �
           1259    135753    index_users_on_email    INDEX     G   CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public         nolan    false    268            �
           1259    135754 !   index_users_on_filtered_languages    INDEX     X   CREATE INDEX index_users_on_filtered_languages ON users USING gin (filtered_languages);
 5   DROP INDEX public.index_users_on_filtered_languages;
       public         nolan    false    268            �
           1259    135755 #   index_users_on_reset_password_token    INDEX     e   CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         nolan    false    268            �
           1259    135756    index_web_settings_on_user_id    INDEX     Y   CREATE UNIQUE INDEX index_web_settings_on_user_id ON web_settings USING btree (user_id);
 1   DROP INDEX public.index_web_settings_on_user_id;
       public         nolan    false    272            z
           1259    135757    search_index    INDEX     C  CREATE INDEX search_index ON accounts USING gin ((((setweight(to_tsvector('simple'::regconfig, (display_name)::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, (username)::text), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(domain, ''::character varying))::text), 'C'::"char"))));
     DROP INDEX public.search_index;
       public         nolan    false    200    200    200    200            3           2606    135758    web_settings fk_11910667b2    FK CONSTRAINT     }   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT fk_11910667b2 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT fk_11910667b2;
       public       nolan    false    2810    272    268                        2606    135763 #   account_domain_blocks fk_206c6029bd    FK CONSTRAINT     �   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT fk_206c6029bd FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT fk_206c6029bd;
       public       nolan    false    2677    200    196                       2606    135768     conversation_mutes fk_225b4212bb    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_225b4212bb FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_225b4212bb;
       public       nolan    false    207    200    2677            -           2606    135773    statuses_tags fk_3081861e21    FK CONSTRAINT     |   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_3081861e21 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_3081861e21;
       public       nolan    false    261    266    2803                       2606    135778    follows fk_32ed1b5560    FK CONSTRAINT     ~   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_32ed1b5560 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_32ed1b5560;
       public       nolan    false    221    200    2677                       2606    135783 !   oauth_access_grants fk_34d54b0a33    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_34d54b0a33 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_34d54b0a33;
       public       nolan    false    239    243    2760                       2606    135788    blocks fk_4269e03e65    FK CONSTRAINT     }   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_4269e03e65 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_4269e03e65;
       public       nolan    false    200    205    2677            "           2606    135793    reports fk_4b81f7522c    FK CONSTRAINT     ~   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_4b81f7522c FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_4b81f7522c;
       public       nolan    false    248    2677    200            1           2606    135798    users fk_50500f500d    FK CONSTRAINT     |   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_50500f500d FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_50500f500d;
       public       nolan    false    268    2677    200            /           2606    135803    stream_entries fk_5659b17554    FK CONSTRAINT     �   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT fk_5659b17554 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT fk_5659b17554;
       public       nolan    false    2677    200    262            	           2606    135808    favourites fk_5eb6c2b873    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_5eb6c2b873 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_5eb6c2b873;
       public       nolan    false    2677    217    200                       2606    135813 !   oauth_access_grants fk_63b044929b    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_63b044929b FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_63b044929b;
       public       nolan    false    268    239    2810                       2606    135818    imports fk_6db1b6e408    FK CONSTRAINT     ~   ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_6db1b6e408 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.imports DROP CONSTRAINT fk_6db1b6e408;
       public       nolan    false    223    200    2677                       2606    135823    follows fk_745ca29eac    FK CONSTRAINT     �   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_745ca29eac FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_745ca29eac;
       public       nolan    false    200    221    2677                       2606    135828    follow_requests fk_76d644b0e7    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_76d644b0e7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_76d644b0e7;
       public       nolan    false    219    200    2677                       2606    135833    follow_requests fk_9291ec025d    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_9291ec025d FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_9291ec025d;
       public       nolan    false    219    200    2677                       2606    135838    blocks fk_9571bfabc1    FK CONSTRAINT     �   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_9571bfabc1 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_9571bfabc1;
       public       nolan    false    200    205    2677            %           2606    135843 !   session_activations fk_957e5bda89    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_957e5bda89 FOREIGN KEY (access_token_id) REFERENCES oauth_access_tokens(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_957e5bda89;
       public       nolan    false    251    241    2756                       2606    135848    media_attachments fk_96dd81e81b    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_96dd81e81b FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_96dd81e81b;
       public       nolan    false    231    2677    200                       2606    135853    mentions fk_970d43f9d1    FK CONSTRAINT        ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_970d43f9d1 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_970d43f9d1;
       public       nolan    false    200    233    2677            0           2606    135858    subscriptions fk_9847d1cbb5    FK CONSTRAINT     �   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_9847d1cbb5 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT fk_9847d1cbb5;
       public       nolan    false    2677    200    264            )           2606    135863    statuses fk_9bda1543f7    FK CONSTRAINT        ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_9bda1543f7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_9bda1543f7;
       public       nolan    false    259    2677    200            !           2606    135868     oauth_applications fk_b0988c7c0a    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT fk_b0988c7c0a FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT fk_b0988c7c0a;
       public       nolan    false    268    243    2810            
           2606    135873    favourites fk_b0e856845e    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_b0e856845e FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_b0e856845e;
       public       nolan    false    2790    217    259                       2606    135878    mutes fk_b8d8daf315    FK CONSTRAINT     |   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_b8d8daf315 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_b8d8daf315;
       public       nolan    false    200    235    2677            #           2606    135883    reports fk_bca45b75fd    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_bca45b75fd FOREIGN KEY (action_taken_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_bca45b75fd;
       public       nolan    false    200    248    2677                       2606    135888    notifications fk_c141c8ee55    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_c141c8ee55 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_c141c8ee55;
       public       nolan    false    2677    200    237            *           2606    135893    statuses fk_c7fa917661    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_c7fa917661 FOREIGN KEY (in_reply_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_c7fa917661;
       public       nolan    false    200    259    2677            '           2606    135898    status_pins fk_d4cb435b62    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_d4cb435b62 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_d4cb435b62;
       public       nolan    false    257    2677    200            &           2606    135903 !   session_activations fk_e5fda67334    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_e5fda67334 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_e5fda67334;
       public       nolan    false    268    2810    251                       2606    135908 !   oauth_access_tokens fk_e84df68546    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_e84df68546 FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_e84df68546;
       public       nolan    false    268    241    2810            $           2606    135913    reports fk_eb37af34f0    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_eb37af34f0 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_eb37af34f0;
       public       nolan    false    248    2677    200                       2606    135918    mutes fk_eecff219ea    FK CONSTRAINT     �   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_eecff219ea FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_eecff219ea;
       public       nolan    false    200    235    2677                        2606    135923 !   oauth_access_tokens fk_f5fc4c1ee3    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_f5fc4c1ee3 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_f5fc4c1ee3;
       public       nolan    false    241    2760    243                       2606    135928    notifications fk_fbd6b0bf9e    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_fbd6b0bf9e FOREIGN KEY (from_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_fbd6b0bf9e;
       public       nolan    false    200    2677    237                       2606    135933    accounts fk_rails_2320833084    FK CONSTRAINT     �   ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_2320833084 FOREIGN KEY (moved_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.accounts DROP CONSTRAINT fk_rails_2320833084;
       public       nolan    false    2677    200    200            +           2606    135938    statuses fk_rails_256483a9ab    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_256483a9ab FOREIGN KEY (reblog_of_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_256483a9ab;
       public       nolan    false    259    259    2790                       2606    135943    lists fk_rails_3853b78dac    FK CONSTRAINT     �   ALTER TABLE ONLY lists
    ADD CONSTRAINT fk_rails_3853b78dac FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.lists DROP CONSTRAINT fk_rails_3853b78dac;
       public       nolan    false    200    2677    229                       2606    135948 %   media_attachments fk_rails_3ec0cfdd70    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_rails_3ec0cfdd70 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_rails_3ec0cfdd70;
       public       nolan    false    259    2790    231                       2606    135953 ,   account_moderation_notes fk_rails_3f8b75089b    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_3f8b75089b FOREIGN KEY (account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_3f8b75089b;
       public       nolan    false    200    2677    198                       2606    135958 !   list_accounts fk_rails_40f9cc29f1    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_40f9cc29f1 FOREIGN KEY (follow_id) REFERENCES follows(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_40f9cc29f1;
       public       nolan    false    227    221    2716                       2606    135963    mentions fk_rails_59edbe2887    FK CONSTRAINT     �   ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_rails_59edbe2887 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_rails_59edbe2887;
       public       nolan    false    2790    259    233                       2606    135968 &   conversation_mutes fk_rails_5ab139311f    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_rails_5ab139311f FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_rails_5ab139311f;
       public       nolan    false    2696    209    207            (           2606    135973    status_pins fk_rails_65c05552f1    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_rails_65c05552f1 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_rails_65c05552f1;
       public       nolan    false    257    259    2790                       2606    135978 !   list_accounts fk_rails_85fee9d6ab    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_85fee9d6ab FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_85fee9d6ab;
       public       nolan    false    2677    227    200            2           2606    135983    users fk_rails_8fb2a43e88    FK CONSTRAINT     �   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_8fb2a43e88 FOREIGN KEY (invite_id) REFERENCES invites(id) ON DELETE SET NULL;
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_rails_8fb2a43e88;
       public       nolan    false    268    2723    225            ,           2606    135988    statuses fk_rails_94a6f70399    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_94a6f70399 FOREIGN KEY (in_reply_to_id) REFERENCES statuses(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_94a6f70399;
       public       nolan    false    259    259    2790                       2606    135993 %   admin_action_logs fk_rails_a7667297fa    FK CONSTRAINT     �   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT fk_rails_a7667297fa FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT fk_rails_a7667297fa;
       public       nolan    false    2677    200    202                       2606    135998 ,   account_moderation_notes fk_rails_dd62ed5ac3    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_dd62ed5ac3 FOREIGN KEY (target_account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_dd62ed5ac3;
       public       nolan    false    200    198    2677            .           2606    136003 !   statuses_tags fk_rails_df0fe11427    FK CONSTRAINT     �   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_rails_df0fe11427 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_rails_df0fe11427;
       public       nolan    false    2790    259    261                       2606    136008 !   list_accounts fk_rails_e54e356c88    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_e54e356c88 FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_e54e356c88;
       public       nolan    false    2731    229    227                       2606    136013    invites fk_rails_ff69dbb2ac    FK CONSTRAINT     ~   ALTER TABLE ONLY invites
    ADD CONSTRAINT fk_rails_ff69dbb2ac FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.invites DROP CONSTRAINT fk_rails_ff69dbb2ac;
       public       nolan    false    225    2810    268            �      x������ � �      �      x������ � �      �      x���I��Z���'ő��7p��}c��4�5`:��8��Uݬ��:������d����XF�Ð�ӷ�����\/��wۡ�����]����<{M�����������=���� j�m�is/���;$=˫�Itx%(�S����4N�����v6D�|��Y5+ő���T�wR� �j����5�` �JE<��nO|u�DPa��kF��'�F�l��z*@rx��L����մPUȣ4g 	ŭ�b�@�ɍ ��g?^�Ԍ~��[�<�E��EXG=^2���	p: �=������.n�L��q'�\C�7!c�?�8נ|���"��(��dP%��NF�:dv˒�G��Ti�`�#�!��c��G�$Bg$I��#s�E3�p=qF��â�)n>�dWb��j�� �E������$�S��m��&�,�-���Q<��4�%�|/�g�v@G�O�G���J�(��M��/��pP]2줊��w畛��h�D�`��Y�!��':0� �fV��9ҋ}#M���I�\G2w.�΁qM_������3��nD�٫ʴJ��	0�āڢ���Z����.��"Y��c�^58
�g�����q�����)}6� ���{���8��R�}�+�tv�#�{�f�Ϟ�2�x�y� ���nD��b�1�mЎ=4I�`i.�+����3�PMX�A>����^9�Yi`^N;��ᲺO�����<z�R�xN^�ā���3O�����={̰�Gy�����,��4��9�l�N����5D���;��ms9&��3�[�oϾ��|4!���lƪ�B��hg�T�[��)l>�/~B�	�>�[Ul+*)����uڻb���|���Sե�#� �A�?-�m�횃&���Fs�#(S8vW۴dWP�bpsg[�A]��E�Im�';��9�1��~�5��>O�M����щBz�<�U_l��������=(���j��c<�7�  ������ ��!]1D�\s��;ۡ@� ���q�^����0�2�;��0f�wK����Z/�k7���}'���V�7�3>w�dp��PK#�1���,��5��ز���&د�,l���2���QTI�m�@��v�@�|���܈d��Ii`4V/���s�BK_Y�2%�K;f+��d��]|��<=臼̫<�"LhϏ��ͬ��)lnw˟�/�#=�t~���;i�]��/�?W��{���_V���H^��M_q����{c�Ϟ{�V�d���!%ު%����78�߂x��ɽ��"� ).,��g�w�]�W�Y�'8p��[�5��z��ʝ�vYYI`ʭ쥝�@�{V5���ǳ�	^���S�Ǩ2���b�֙�}Wm-R��H%дq������N�����ׯ���ů_�׳��_�B�g��~�^��+~�
�����ןv�����u!L�B���a�w�"~�
#�����r��_�Ͽo0���T�낮�����o�u��{F뿽�4,�?�[����B��2�2n���H���"���q1몄~�<����
�a$��X� ��"B-[㊍��<S����Gm
���Rv���b!WAr	q
�����\��g/���
�5�]@��t`���ǳ�����R7$CJխ�ط\ �ϕ��ǐ4X� ����r���j>ޘ�`_�5��nm�m���s�Oj�L�8�a���8-����IL��x��Q�E��u�AUvݥD�z����lK�(J�](cj��?y��Ռ�k�����l� -b��MВ����t%Q���Pj��	���H�S��q���ޝ��"\�l�����A��~Gh2�ZX9�丙%�R��U�&�ɸF?�����N�gO/���$���� ߓ4]z5��*�fi�A�S���}��urC�$P �zѭi��z����1 ��r{f�p@�J��Q�Jd�z��X�0��ɑ�*������˅�D�Ey$�6�p�=F�9�g,��n�L:p<�� YM���n?���Ǎ�0�������'�df.Q�<���!��cq�X��I��:�)��vUx�m�]C!��7{_��4ۑ#C=���[6�7P��C; z�a{O��y�	'䔀�������:��n����#Q��<���U��;�fyx��{��tT�{{���R�%�����1�{k���h!m5�އ[��A.�"�e-�+T0wU�fV��tG�`^�U�I��+��G&�vã�ړ��8�ɳd/�i�đ��WP�ﮀ�����M=OF�1S2_pu�ņM�;�|��X����h�,:f����-q���f7(�q�:����g�ۻ6�u�0��i����H�Ӊ���:B�I=&��$9<,>�&��u��):ZK�������pp�6��t ������J���O��SfGh�$S=�(��4{��;/��v� m˷/H�,u�C��ժ�ؤ��aҨ���͂w��3�.JzM!:�Yd�=�G�'��:�g:oiI�����m��T�?���(����7@X�e-\��u�3���Vi���ao�#�܌a�#m���P
���oᰙ����5YM��+�8<��1��l8++������h��ē�neDg��˴?��YWu�o�]%f/-H$g���Lku��c!	��>G����a�D�����+�]���a�B��|�`د��Ű_!�U�_0�W��bد��!�/���~ǰ�Q�7�"�?��?/��A��|���>�8{��_8������i�R��(hyGX9�ā-��L���}"6W�^R9/���|J>*��n[Y �)�̊�9i����r�A�uťcT'�Y��	���[tʗ�Ce���լ�z�j+�ʽ�n��ף��#n�*�
���}�C��5�D���5'���=��v��*\%��)���{���?Uty#�l~�5��Gj���-������N��Ԥ���-̨�� m�v�j㒇�
��*p|,G��a|CD<<n۹�/w�x�����l��>8*�Y~�����F����MO 2�x\�i� �g�1+'�0�<��)8�R3�������c��i��(q�SA�lSa��D��T�\2d�/���v��ٺ@yܯ��{�L��?��5�$�g�ك��=w���@����-/a�����Ԏ<K��m�^��<x��pO�p��v���+!�#���M��:�K?�����XG�6]㺧��=Ȗ���8_f���t0�w����櫙m95�7��K����1�����Pۗk<� Q��?}�{��^�s¥t�:�ӡ�X�t!^C�(��0��a<�/��n볟Y�3>ZC��G�)l#7m����Iz�U9�җ����m���h ��)��^mFb��wJ���{�0����.^��R�E�.��ۧ���Po%��F 4te��Pq����,�����v�)����݀��%#V�TBg�� ��U;�1k/}*�ecX���Ѫ��zЈ_��c��R��~���� Z�`]¶l+-�D:��p���}d�8� k�k���b�r��m����~hݱ�l��e`�+G?B�ǰ�]�$��(F��Lg��Stg��`�9|�����,o�13��@���wЮ�`)/�Dz5�ˈ�����,�j�b�m���W8F?��^�5�l%Ħ1��fF`S��~�8�a=�)��b`��V��|J�%D	���<*�}h�����xݣ�> L	v�xIw���V>t�0Q��
�5���Q�I����i�v���ҧP@2����d��q�KS�RsvA�H��[3|��H&���%ӱ5��k��j�ozZ��=���M/��QI��f��c�emK\�����L��Dpͳ��0��?z�f8 �T�8�H�q_�|8��Z���[�Bh)��#7eD�9���+��E�JD�o<��Cy�(�C��ѻI���md�6��ߝ�ſO|������_�B�+��ׯ��	��ׯ���ů_�׳��_�B�k�����<ف��a��� �  ���_���'����W����S뾝���@>x�\����	e�o���G�� v����A*���}ml�h@�ԟԱ�l&'1:�I�|�N1�w{�yH�#����p���?����Wy�+^��=�\N��
%c�>u�,����j^��w��Hvg�\�J�~,#�sl$��0��pi���ܚN�BmKԖ!��z�͠��&���ǖ(m���,M&G�{��4�<atNv����V����N�Jc6yGQ�E��6羚��V�e��2�S*Rd�	S����� 	��A�ҵ!�B5$���E}{4�t���ڳr�[�TJhc;#�7�H��-�t�F*b���ˁ��væ���� R7�k�B6ϡ���O�?]��1� E=@�jhIT�� nbW�	n�./�Ij����حtө�aC#��G��C Rȑ"��>�=����w���W�-e|�5HE(Vλp�r��,�a���Ԁ��[C!)ʕ�[Uw�6�w6m�y�K��T�������`�%�7���; ˂�Q��R�rlSH��[���P�Q]O��G���~� �����m�T�����Lx�e���i�U0r���<�H�8zD�/��5'{�d�cfPr�'�!���Ƕ�ّ.�V?�����%:
���v)$���ƴ'��Pf{=8
^��fs��h�k�D'aw���%������#�Sk/!��!�o����˵��J*aC��`��k�]�����H���ML�6��u���H V՘z�!`���ꍌ�QMP[%�sY��O�����F� #ûj�/����5`��a� ��L'Xl�\.H���&]�2|�Hi"G���g�be�C\.u�xe���y�E����YG�iуK���.*'�w:�Jb��.	�f��ˀ�0�,]���R^�=k.>��%mDi�WkOLj�d��Ѿ��(ύ�dh��ۣ@r,I]}���w�����\a��5Vg�Ӗy�ט������ࡵ�}��y��6�I��>�D�(�p���0�h&U�c�
��CF��kr����Ի�$��an&j�Ag�����6�}
j.������U[���¹���g�ܫ�~h[�{sT@�X"�|d6��'�A�h��gΜ�r�˽��҉����<��-\1���&����A�ƃX�i�����>��vE���>��r�/k�G�n��21Y$���!���$�:�P��$��fk�؏�q��y	P���_���ů_�׳��_�B��.��ׯ�뒰/��+�z�_��W�u���$@��!�;����c���0����@?���Vy�~��{�,��;6Cݿ�y���m���q�}�?i����ϥ����m������㇯����u|/�:������з��.�����=�������X�       �   �  x�ݔ�n�0���H0��wU�'h�J�Ǔ8)y�^M�:#M�Ŕ�=�^ε? ������i���݃�b�$�5�B����q�V��\m]_�����
����t�3�.m�/�t�w{�q6h��<�ᵶy'�6��4�pN��ih!Y[VA�o~��7�~�MP?�`���i �Rצ׿L��uV�)4
}'�b�'�%� L��)�[.0<�v��@x������my�����\
f.\�I�婁�j`���_�w/f������mpkƪ�4����z&o�[��w��ws�Ɍ����`�G�
~��hm/!�`�)��p�N�	Ρ
�Q:gӉx�g_�'�)�$��\���Dp�?~O�缗$2_���u<ق'���֏���ixn3ʾ�N�����l��B���ot�{II)? �|��ٝ�}t3j�h�sD�[%|�Bbq@��4���,Q�!      �   ?   x�K�+�,���M�+�LI-K��/ ��-t�t--������M�LM�Hq��qqq ��h      �      x������ � �      �      x������ � �      �   �  x�}��q$!E�WQ8Sz"� 6�Ǫ]5m<���Gw�AB�|���,��SƇ�K��:�X? R-���"�Q��}��?!�Ai��� 
�ƙ!蟾u�ZT�����ޘM��j�y@4qt6u��A$�!��3��Hg�e�p�"�:�7	�>�H�Omz� �}	V*�Yr�	v*F]�@�}!$U����蹙� dUH���~D����{2��� �� Z�ξ�ՂH�WU��G����)�
f�h�/D���p�.�ՃH�WU ��D�"E^U�55��?�YU���v�@���^פ�N�A��(�����[)6J�=(��Sz!Rl�J�FD����e������O�������oѥن׊ȀOU���F�; 2��}���ǖ]0��ml¼�yAd��*��i5A����������_��X�|����y�"2`U�Ӆ�-�}���������|�+"^�|7��)������Y�h:ok^9�
��>�޺"��^����n*���Qm�<@6�7W�}f�"�8�ka}x? �|�����,�Er_�����Z�3���'�z4�0�D�0[�h� v@����W��\[݆(���C�^!��K�������k����Q8�F=&2x�Q�΋�#z� ����u,      �   �   x�}�M
�@F�3���&���x����������tl����Ń���5��Й���<��m�3��@� C>� ����(g94X9���<�n�����4̼�@������x�P��Ĭ���4�C�MC����D$$%"�'fM(���Z<\�      �      x������ � �      �      x������ � �      �   �   x�}���0�ai���Z���Èc�'`0���,��.�w��>Q#C��
ɭ^j���nң��2�4-�Ыպf�Y�K������B�V���B~`1`�*��dN�P���v��`l̜QR
:~�&�p�����[��}��(�d�����>�ZW),M�1��	
=eq      �      x������ � �      �   �   x�}���0C��Y���O"i����Q7(� -��EbFt��X��((�����Hq���a�i�*�2�Yig��3�g��/vJ(������W�K�Nnc^�F�h�[�ζ��o�H2�Y�ٹ�A��'��E�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�ՖOS�H���OA�'�=���7l�I�
�TQ�$���oR|�m� �Y��TmT>���߼�VT12���!D 5�[(�/�)2}9��4�.��HA`N���6؆��C��F�K�5hGb��H^#Y�:�[�����m��p���`������nƣ�u:I:_��q��H:��l&�xt�L:�a3Y��I')��$�I���Ƞ��B g�%w/?����#��!:��P��|��Y���@�!��W����eq݂��2�� ��1Y�b�3?��ڒ� �֑�Z����B�ѻ��?�|>��S{���_������#
-|DJޣ�8�@!M�s�E�֑�#�z���2�� *���mlu�$��U���E�ٞ������a/�R�)Rx����m������)R�~���[�)I�H��W��"/�2p�QYa��X���:�X:�тfo��4%r����W��lg9�v�mx�s�֝��=�0V����T���bŶr�/��m���ā����2�`�1��)�G;�b�����H�f/*��C\�����o��t�^�[�j�A4���d�	[�^�j+�%T������G���9��"�z:'u;΋٫��SD���e-4��F�J�=6%@켑y|�8�
�rv���]���3�1��]e�r�r�E���Q�5JL�diY���=���e����B��<��ԉ&L\4��H���6���t|m�/�γaN{���	ק�� �A��T\��S��&�Hk����I;i����ٻF7)��Q�~��K$�PK?S������n�x4�G;[;�w2����z�\ɑr��k���%©�F ��U"�Cg
 �c��	|���E0�qdKM�0���E�V�A��<_�>�uoz�^o������*	��[��?a�      �   �   x����iD1D��Ul�h�I�e��#손&��9��Gwx��;Z�L*�K�B=��t!g3uDC\ePO"���i4?!{�Okc�L����ߦ0�J�����	.����ʏh���!��=��3�`8����Dd7��vx̀	��Fn� ���@�|�.��^�]d�F��Ž�zB6^s����sI      �      x������ � �      �   �  x�}�=n1Fk�)�+�W$u�t�Ҧq���u|�P�����L�4O�7�`�����z�(�g�3�	�3v�
��l���F�&���\��8Uߟ߮/���Q��O�}��"��Z�+G�9�h�A�o��H��q�����k$q�"��7T_!,�Y��D;h1�X��xJ��	۸��*
-Q�E���&y�����F�62VY������`���ˏ������U�*���x����.<����z�>?8���q���3��wG��Uu�]����N��NX����.�YQh�/�䓬�3T%|P��[�����Z���G�O���������!~��;�!l�#�(�k�����\��ѕȫ�B�
�E(6I��a�7��5wh��v��r"�F
��BXd#�r�w��lth� [�
�.���u\ N�Ϻm�_��R4      �      x���]r%�����Fq&�m�� �A����;�'��?��em�ũ���$�$"	`�E�H��Rv.c�>c�իfI1�0r/m�*q/�b]b��"��=W�Kʜ���=���������_G����o��s�[���������������������6�#8_���|�-�O���<s
1��P}��m�V����������������}���/�/W�u��[�ÇU���Tsi���vҜkJ��f�^C
���ӧg��7�!~_��L�#>��_���sP�#��J�NV-aF����]�y��.u'��JS�k@p��>UCt�8T����䱘3>�Ug-�i�K�����Cв�֡y�Qr��wum�Ӱ%�6 ~�����!q��t2@0 =�d�N��!#��E��k���!eW���G]�Gq�����yK-΍0 ���K<�h�r2����J�Lӥ�v��m?q�j.nyR��GLa�*QØ�u���ϐ���p�]�����AKL<ִ��"5�K�<�0�J��Ys	�/��s�)�+.�����U���B)�����(��J'��2G/��I�ٹ.I�ԩ"y���vq'���D�WɾrۀD�|:���q�|襞(P;�����a!�μx��X��{���G\�PN⇒�,���n��1?���?aX��d +���#IK���W�˹��o-���"n�����ܛ��)䦞Zkn��~�!T��w���F�Oy4:��?RK:�rp�h������W���ޏ�*А���]���{ۂ��ʓ��;���H!ZO�4���~�P�i��]j������ �3��:i-�u@��>̀y~ "�,�
�����5T%�|JD�����ʓm"�7�?���$��P&
QI��66_M�\�C��{Ŧ]�g�l|Oq�-�^CE��r��И�׶R�N �Es����[�,�P�H�{I����UFv�C �ݏ������R��k�'{�,08���t7[.{������t:��-���L
Ã�&rt*q��- �B�򖊮�� {}��/w�3�p2���C�bO����l5�LmJ �Abߓ ?`@�OxJ�o��"��#G�c�� �YZ��$�m3���
�r���	b��c�c^q�"T��	�U�z�r�1��d�,�����8�q��ZV[q�-�֬������ৄĚe�J?a�>�0���??��Ⱦ>�K��ڔ�X�̾��s�'MO�>T�M���Y��Lu	*��	��o�Fj�)�E4@P�Ցz�@p��8���`I(5G(���pF� �$oEJ!(~�t,n8YPmY�)�� }Y-�����JΎ��+��9�����Z�*���W�()%�Q��J��N�������(�K�G������T_�㞩Y(�k��CB� �	{�����)=�S��߇��d�p�Db�Ն�i�Qn�����D-�/e��HKbE�E�;�:��:��W�kAt��=d,�ǯ��\,'8d$&�2��&�'D�,8n3�#��Hd�f���
�t 1��6��H��>�w�~_��P�>���k���q4��CpEa���W��8�wq�Ts]S(�-�Pڼ�����g�1ƃ�Bh�rQ��@	v��'��K�&B2�_"^�X+4��]Q?1��4�L��6��%�mC�0T��Փ����@e� L���{V�׬���,�󹶖c6�\̢-�BÐ:��rۂ�k�J��M_CI��,0V��0Ј>h{,��*�kعD��D 
��������7ܺ�9 �6"3M\�R��l�
(�z��d��I�wsL|z��<�e�͇�ar9�ڕl��t�KM�����3��n�5
�9<%Zx�Ȑ��cE��C#�hE��2��Þ<� �1��va-�센��Y���=��נ|� �}��E�k�l�z��hW4���ׁ��S\:�f�����P��.�o�ɐb� ��)<���=�2���k`����w&�=ֵ��ȿ����{.�O���bG��-�:���3-O�ŷ���P���j��	
����LD�����%�j���`�I��B��LQ� zW����&	���חS2p����.������`[�����ռ����ȩ�l)V�&���L+���4y��	�,����É���)���s��.s�Jۂs$�{����~#3�%�_� ���b��ݛµ��oKp�,���,�@�(�I�t�Zd���\���3�f��O#)Qgm�|^��=�d��Y�5�{"�!��Зz"j`�Ƭ�yX*���H��|K�&xa؞�S�b�)i);���Z� ��'�@�38	��^C�d9a����� �\HF)d�ӑ�-M�5H�mnd��0;_v�|�J �mk����ї��F"�5��dSgR��T�{��2�DuAQ�����pS(P��`����a[��f�p�O��x/y��!u���,�H���g�~b8�h�kK#�n���p
\�(jĐ�2eL~�X ��V��!�8�S*����Z����F�h����O��-�ei�}�̆t`����=��a��		P���^C0w<>֋Շ�&��Z$ffA芡�����3:������)0�[t����eۥ�M���JD�ɂˋ�c��z�c����Ɵ���B�����nB�ن��G���on��*��˓< ��O��[,��y'TY�D�ԍ����Al;�k�T����!i*᩽����\tMS D��P.rs��"�����t�������k��`Gvk�{���D�a�V8�M�|M3Y$�2<	�Y�+�,t�ԁYz[����&��6�vC@���,�U����2�߷y5I�ŧ���ؐ<}ђ���rX�	s��l�t�D�A:�o2��Z�%��:�*L^�p9-X�}^��������3G8��(�c�ȓ�$4�6����P����6�\��P��4:�``��vc��M���&�!���S g�u�f�ӬPbJs�~�2�Pl��L��	<��n�=�m7iacarۂ��ҳB��fH!��n{{$��W@����� �c%�l��n 	�#�Mx��aM���<Y�0 ��e/���"��F'.^���q��J�3�J�gd��HVеAmpn��+�3q��3�/'"X��[�o>t�@��q�+[*�=Sg��cA�Sp�g!�ؑ7?��[����N�{��8�d�3��� �ḋ�>��9��A�R)��6��z��c�ǭY�>y��5��S�����j���i����<��F)�!����J�>l�1MB����w�w�u'jg��Kid"p�;�;��R���/̲s���&�k�*�D� �#��F�ɬ�%U��D?]�D�ZW�����
)�ٚ۬�NrS�}�۹�i�7�ʘ#����(��4}d;�o��&������{]��#��$!�}u(�"����8��i��Wyc����	����)A��w���}#66a�՘����>���!��(�q�Y3�hJ�X!P8�Xp,)*W���v�*����
���$��� 4HNv�֛t;�-��z��ɧ�� ��r�I=Q�ri�����p�jVw�
<²iڢV�8�[�M���{@��8fݡ�����LW1���o��Eݜv늱:u'ۅX��̑�&h���+�YFe�P��V��N��A���o�\Ӵ�}KE�b<���)US7�>�m$pl f���aq���a&#!GD5�}-3���Z����',�s�*o��u�%�����C-��)�-�Q�*ɳ���A�8d��6!��t���Ƃ���p��ZުA^C�:�s<Er5H�n��C\�֝��%%��ig�1^�m�5c�[+AVu!�c�R��s�k������?��i��[*��v�mNZY�H�J!�=۰L�K�qA�m��銈_7E�k��S�*�!�ϑA�iȇ��I/���-�ґ��%��
�@�K#h�6�yt�]%ٗ�}1��nP^s���!U�#��W-�>\�R�ԅ�kO��mSĈ�1�fG    ;���̨F��2˧��`����S<&}���"�O;?
��o�DX�:��DҀ/�c$}�3�}	>��n�Ӭ��������5D������hy����Zx���cEd"++��E�n���y�e�PU׃Сvz�O~���U$`z�նS�#�S�/��;�#
�$P���o�9��.���2�ّ~��ju��$�vxo	����;ux�(UO*��f�@�@��퓸$d�iz�o��Vٱ�	c��� �.��A��w�f��C���oD�X�@��yg�K�jHù�P�EV\�� �4V?�^��R�������_-���/~��CQ��%���L�3��;i&�
�YВ�V-�i�mXI�U�wȜ�աz���q3�o#��O_��kW���Jj?��Ao6���6D�P9��nCF���X�au�P���)wo���V|�HB���^C�U0P,f�� q��~��p��|�+Ez�(��^%�f���gݨ�ې��m���b��l(�AI�g�1�ܾ�"�u���,iI��=,�H+��Ҝk�>�f|�>���^Q���]N���/�_��s����)#�7">G3�P�̴����1�7d�\��d�d�M��.��j�^Cj��g�kN���cCUS�-[e��G�)��8��aOH4�Z� �&\��@����D�sB�AQ�[x;����a{�`�L����#b1���N
&�r	:�L�N˶{��}w=��vR�{��.�����אB揗�j��\c�X ��R���<.H��O�V�cy�G�����k�����	���Oe����舁l�rB��F�n�T0%��7f
*�@��Sc���<��M(v�
?��=�mp6�zRd��?��6;N xE8h\�@�]ё Jf~e%x_�@���k&�9��o�UP�gd��;:��ǣ����>`}X�.���#���Y���v�4/�6�w�����J�FZH��,�*���V�&�_Cd��	�����</�嗟�~�W��U$`r:*D��A3�4������S��5��{(�����H/��G����me�R�H���H��46m764�E�f_�D�A�KC�ް���M�U���@��$N�ODۛ��(�+��	R*�)� ���~���Q$Ü%a��F��}�ڴ�;�_�$�;��8�ݙj{6HɮpcNY���αJ�jMm&K��Qv��x�&�\��R[�V(���~�a%ȧ���ŵ9����6����Rm'T3��5[� ��i�����v�����;_�$o�=�_S�/C�v:n�ڭRL(ԥ7�w�Z����V� �1oWxe���R��R��p���mK��JK8��\H�+�ގ;?��=���R�XѮ7!�ez�NrB��>�m�$����B�+5����<�%�l�o�teԕ�����c+����0D�ۥD���n��WдB�|��h@�j!đ��-w��5QqV/���"�/#�v&y�;�(���`�5Ԟ7�6CO�؆H���heDv	�<گfݐ?�כw���D%�9��`xYǆcu�]�tv���W@$z^-��F�(躀����Q�K�*�˶�Y*���m�� �*����=I�@�ц� �c�f��b�+�[��p�׵��:�'V(�Ą�u�ܨ����rE��T�/]C�D۔?�p]�3�=BnΊc��a{�ae�������	#{3��u�l5!���&�m�9}�^�H�e�M9"�\7�!�͊0��t�O�V�;׶I!�vD���lv!�how��޾�NKVڞ��5���5���V�^;M�:�ɫ����������Dٙ� v��t[F�;�$"����(�4Y��J��X������i�H�ˤ�6���a+s�3�FN��wǎ�zf�]g�s�^�_w�þP�r�^�J�C�t�[y���¡�G��L% ����&e$Y��%��2{d\�������[gʯyʧ�иomC��p���u\��aMet.\���C �x^����j��JF3R�����>솻G*��Mȟ!ZuH��dC��y4����c�]s];����zK!��Cj0<]��Թ��]����i���&$u��h�5�~�IW���,N���<s;���$�ԡ���ݪn�/�n�"'`z�q߄b͡"d(���5���Ύd��"@�K�沫Cv�@��X �����Eq��s���A̔ m�^�u*�5�Qf�F��!R�����mNy�jDd�M^B�H&(P�9#q|�C� �Zȳe�=l��\�T��|�6�Zw���v���	Ǜ,��v�PR+X��T�*�o�(�e����_��d�	�O+z>�����2��}TvR����7�c��jb���m�	�
{��rqK�:+|�wS�lDCԈ>��J��C޹�7�eD�qo�����2���@��3i�d����P\vMdx;��+��j�r��k%@.�Rם�ٯ�&��Bl`�$��y���3��	Ц�Sc��EP�&h���(0��EB͊��,�FI�А�w����u2�Vǡ�R��/��1�f�z.d�Ȅ1��v΁��v��|1���p+k��)i7��޺_��(B�x@�7�!-ȭ#˸z�%Ĕ_��BK[�:�N�<s^��]�lu�jK�~�1a.�^)[�"��=��=���=�א��\����^x����,0R+n����-��S��	H��ᴤ^���@j��]xF9��^�͎���`�Vz�h��s�V����b�j}�2�饷" 'xP���.��m�ԧ���mc�"��?of�#�뫶���� ,�l2hs0�[��;�,/��7?��[���
�Q��շE����Mx�����J���YC�Gq���UC/�X� 
�h�ؒ-[��� ��Ֆ/���2����5�u0�c,\���z�yi��$!����W	뵒�k��.�µ��1�����}�?�k��J.�w�=���{�yޝ�+����K���i�����|V��f��jGl�OHV���P�,v�\���L_�����N�^C�8��jѧ�*��J��87b�ȵZr�\Y���qYM a?��
�%�7;j߷C����/I-�����t5�����0$5�!�G��./ke���v>�8M�&�E�J�;o	w
R_�3���1����
�^]�u$+��k�P։ï6�n0!v�ݻ�;�<��Bi��nuP���]k��� mC�i���U1���!�le��Y!�į���I�x���$�E��sdud�T��&�K
�&�k�磷�%�mh�~��#b �vwD,���I�u�zX+�qH������:H|Zӛ�א�?ґd\MilGásv�k+��I
�a@�I�V�`�#��/k95�m8�.��(��[J�LA�x㫯�j,�6�5"�/
��,º �3̆L �=69q�_��n�X��	���~<_�lJ",o�t�DqdJW_#qy��Q�1��if��R�xC�Y���Yw �V�9��R���J�Փ��7�*��M�6\��A�ؼl�э¡v�Ε>_��Vς~#ZlG5�!�����}���6?̿a�5du;�.�&ܗlij��H,������y-�.($1������T��l3ZO��������p�]��������N��[�nkS�ܶ�l+X�er.|o�h��<�
X���a� �j�󖖮�2t�hë�n~�U{ȱo߮:k	����O}�m�[�j����]�|�f�kl�V�OH��C��wV,p>p������k��x�9��}����e�� 	:�Psk|����Ѹm���:�q�[<\CF����W���D7p�Gځ�v'vC[�B������0�ܬgJ�����6�m��o:��!�1�s<\0mM�Z#;�iaX���و��[��^|�X*�vC�FGZ��ba�oբM�Բu�<��P���#�������~O;N߰��d��֠v}iԁ��ߵ6��E����|���*����\kW㞁�zld鯎;�Fɕ���u�X70 \	  @�� V�'�(#�"�C�E�W#@{�?�j����������<��\�R�< �g�Wv�˅� �]F�l�[������M�1���[ݫD��_�%r����M*�E��a�ʗ57`P
��٤O¹�����RaA�py2�I�3�ƭ��_sM��]z;��� ��p����a��@Lv�kZ�h�A��)��H�Eș�4���������m�V�����M";!�����3JO��:�p�i���ڬ�v��N�Rق�D�Y����+yİ��2���BKm��v�ˡ�Z�|ؿ?��Ք�v��e2S�W��I��$���̿�ؖ5�{6�-�A���!X��ޞ�k�ݏ|��8��'�S�Wk{ܹ�M�)Hi#��X3���:�����i��V@vWۊN�՘@�oې��H��/eK���q�?W�ۡ�2�B�}�`�tuu�ڐ6D ��b�9�]������y���t�xRj�!Dc9��z�XY��X��ᢗ�th�֑98N�3m��X]���^;��k�|�i�k��ji���3/��P�P���W�"�8�]@J�^a/�{�	'�=A�`��{�A�T�O�Ko.
��6�G�H����y��2���U|M��T����k2��6Bd��̷=a�ȥa]�H]��~��ZM�������8�T˪	V]w�ޭ']�N��3�d�q�Y���>�����ǽn�C�
����K�!�C:�?_����
�l/4Y� 1uWw�QWAmb��6$�A=�e�X70h2ϵ1o]�zM�_��L
~ϭ�����ї��遈�p��mVk��%֝�(F��nm�IpE���Jo���%���o	�|�%�f�:��l�t����)-7��:(dt�Uu�2��� }1���n#����J?bC�g(9��1�20=s��ʭ�1��^�Gs�Y_)�Fu�'n��ջ�e%�d�֣VZ�q��C��mC�^q£�7_���w���Xy���p���^�`�j����m-װ��Ub�i�!]GM8��W�D��{[���F��[_�8���mx�V��v�L�꫈d��
#�!E3z��������8�4J�V�r߆d����q��sxܾ�Z�؁τz.kG+�Z���3��$�4kƾ���9�s�O�Y��}<���6�H�j�>���z�b%G.��b>O�;S�;�a]0�d��+C@d�w�aoA��ZU�N�=����?`i��Y��򽆂��j�b�%Ѧ���:�]�w�lҧk���!���[�ז��l-~.��[`^MWѼ��?+Ϋy�O!Wr$�k*�!/�Ers�gʤ�>g�Y'�����DW˔[�v^S����`�o�{e�pp̠W�;�cg+# �*>�F�e�<Y��)�@XĴ����0����}�Yr�z��੼�p���w���RD˔\_����P��
�: �@��ȜD�����r����|�;��DC��NjxC�׮���C�jCbg;��h��+�禘�	�|�#嫏_��o]�
��G�(�U/���(�T���5$v���6v����r�.qC�'�:�6�iW뚸��<�Kv�f�:�A�
�gʖ'S����ڍ:��xK5\=$l�
�H/�=RF[��I�Moo��(5{�#��\�1�n�9�{/�{M�*D-��7�lC陂�(>��
����P �>��\=��}���$��j�Z�%�^�a/�������B���"��ɮ!�k�X�P_h\��+����M%���>i��,��:��!�~ػ��B:�m���Q@�N�� �--�u�9^/�<�p�����A9�t�N��E{3�m��w�"4/5m�YT���f�<�mH��>�Z���m�!�Vux��k#L-"���U�XopoP;)y���ͺ��\�+mi6�J�4�Z�ֵ���
6�����RM�5m��Hb�S����S��Jѽ�uE��B�N���t[��z�^p5�ۥ[ݚ���T]=�h�k=�pQ�GM���ws�;�����^b�1���gC<|σh�u��kJ����~sb�]!?�6i�Ձ�Îp�pЉRV�Þm���W�4�'¢�Қ�C�\A:w����f1�7D�k��YQNq�����F�=*��������M��$H�.c�2��B��aom�]kD�>R�X�̦��>|�����2�Y����ס�����ɮ��~�	�BޚfrO��ș�q�),u[!�ߥn/��4��|r`׿e��^}C���Go�Ғ���Kp��v6��s-@'I1�5d���u-@���',xt+Bh�#<�����L�j]�����%��9��`��1��qv{=�t"mr��,DT�#x݈�k�/+�k��O`��p�5Q!$���}l�&�O6\�G�������6�	      �      x�}�Y�m7r���F�	����#�[� �<��~n��(q�L���ꐋ���`��i��jʪ�L7�+���s�s��]p���L3ͯݗ����C�-ڒ�z������[�eܿl����~��Dgr-��6�����_�{����?��?�����#<9%?�v�&;Z�ÅR[�>���I5wso��V掳7�h��1���upg~����S������k�bKkv���&�/3��:9�W.��pqDk��m�δ_���B�%�nCzB,�ۜn�VjpfԒFjѬ�J�nƺ�Yv��K]1�`F-�n�}x�cʏ�cBt�o��q�hc[Jqָ�[Xc�ej5���5x���=2[n|_�+��x��8�	!�o��3�{J�ͥX��o���{%�����]!�l��̐�q��@,z�YZa�_Ə�c�aSo�����K�5c|{g�6�b�/�ym��>5���X6j�Y��&�rz]�~l�dǤ�m��;p����.��׬}��lY��a���g�:gB�@p���@룼O �X����m���g��x3�y��Ȳ`��D����lMݱ�hML�B0׽����˖�����L��:���>�L��^�0~K�I��$�����ْ5=���f5Gl��5���opd��$�'^��$M ?���veGg�����[�z�l)&�FO�O�%�tN�i��>�t�)b��h}��ﬆ��cL�� I�6��ZG�4&����G����s�@�������J���c���Z5#0� �b�ư�9�e��i��!Cc�[�+�R]~	?���)(���S��ˆGvldY�8��,=!�\v���~�h>�ATB�(;���gx��glko���'��޵��;F��f��e��Rl��h������l4����� k1ܲ�)�]~����V�S����5{�4=�� �@��A�U��Z�1�mC}?�?.R.��r�)�]}�7@��6�g.4�U��RLfU[a���D �㘝YY�>�'��u���>\O�Q�$i�h���jP%�1�gRk��rۻ�S��6I�:|$�>.鿷���?�M�x���|=2ēw��4�0H���(���L����F��~|����Ы>>��NO���n1b=�ba�3��~�=6X0BM(2�+Ȝ>�O.���gH��A�	��ы�լ	��&�aG��-�S��?,~�>���/#=>�7��B=q�m��V��n��.	<[
��)ʌ鑆��D����2��=\A��s���v�gȤ�L�MBo��Y�h9X�~ǭ�j��I�����2|,�=�P/�G�fm���a�j��KΑ��:۪+l3��<��*�Â� ����ʏ�~h�b��H��6V*úd�#gQ�=�8���W��Xt@�����#��/�;%������_,{v���@�Ed_�0\)�q�z�p v%�(*C+����x�qU�z^��}\k��-�*)oҬ��p�44W�%�eod�'��!ч��->��n.���B�h�=��1�4�fFW5�%�Cz���N�%��6��]eGx����r>}����P�����E�Wd!�V7��(~t�]��P��*�,Ħu9�:<z��7P1��z1>X����c��VʈIj;��}���qb�o/�zpm1�����Q�W�z�7d�2��%7���<����#��	����+��b4��Һ��+�
p� ($2>���Ό�-C�r���$r��m�#�b&J� 8~����ҷ�z�>�{�>�Z.o r�2.�6W���.��m��R�_�V�	?�7��~��1擓'�o���2�F���j���Sq �U�����@�� ���f���س״���m�����'��y�lsA���N�۳!��da����=����e^���C��\��?��Ϗ�����S^d�t�/�a���Ȃ'����Jc��
,��}��}Hl�Ǥ�|�/��d!pȱ�ƶ�����0
�����B��b�`���o���׽Y6?B$憹Q��G���kHi��³�w��)c���i�alq�B�oi��^�ó�2��zQ�$#��O삅G]a��0kL�Q�;���.Ͳ���i���_�>���I_K<Q��C2�Q	���]
����d��g3�?'��ȶ��
g�a��y�j�F�?�g,p.c/s!�"������rS�� G&]����ݏm6�t[����kS���(�/�Q%�03�jz=a2��o) �ao����Y'>̂��H����O4ҙ����O��� ojkr�eaz��"���Z��TdS�r@"d^��s.�_?�������}���6~�r���d�6�����mu��&�_�z��t���:3ڟ`>!�o[�:dD�D!Ց7N�4�0��4&*�x";#/�@ya�s�Ďwb?ۗ�û�����F�I�S��h���3lm��C�F�j1op�B��g6냟/=��T���eT�}"Hq��%e})4[ҕ_�#��O��� ���x���23��v�ڽ i���ؒ�:/	��a����6����^GY���P`� ��ȈDHز�#�췵��S��x��[XMOI��J�*��Z�j�^�}D�_ �у�vU���\�|	=�c��J#�Ms&�� ���X���wӇ���a��ޢ��0�ܾPΙ 7���kNa�l�92n�������M�n��F�}`5���eR/�؃����u؜�����	�SX�ؽ����VBʐ,Z���m��e@ؓ=����w�ZP�{��S���#
+���xo-�$�'J�`��_z
G�:���9MAb�7,9���F�뵸��J�>^�.���}��F�1����A��H>l&�i��UR[!�����"n�K���g���=��贛��H(� |EW�����X��W��\<P��5�}do"y_c ����[�GK��@��E�	Fj���������	
�Fұ��':�4r�@��M���t���S^/�Қ`����ȫ)P�pL�^��]���t�$�����	8�o�૿ƀ=AH|X&		 �t��btHJ�9+���l�8 %b�ڀ��d<�/��S-1x_�s�S�S7��4��3�1q��G�u' ��E�n�d�f��!��Ͻoi���N�>ކp� �*��S�h�u��Ӭ��"��b٢G	w+Q1��?�E"os;\�N +�4��m�23h0�q�OĚ)2T:�ٱ ��O6�	�����(f�[r�)j���ՙ�(*�D8]��Tz��D��â�CB�Ď��lʪ8���(tP�~�n�@�u��سy�:�=;#As����j+��b���d�lMo�:�-x�����	ZfH	�Ļ��' ���}��򞂣�A\7�y�u����2C�owvUj��(�O��ZB����W-t&���&SoȞ��#T��so�H���#:��ޣ��H���7�*#��b�C7�Zo���	D�����Nx� 8Ȧ։,%�[�4D��@C���!Ă��*�?��-�ɗ�N��艂7WnO��}��U���!���[fd��I^Sn�<�A�n	Dd*pS�u���N� � ��+��YWy�@x (ө� X��ʞ�p���X�	�U�cA�@�Y�.�*H��?&`�+�sڅSE�#.���i�b�@��J�#*ِ~�G�n�V��� nȇOq���!� d��u`�K-��N�������,�Be�7�!�A��l�P�M�=Ya�!�a8AȯqA�:}]�����i���ħ&�2�8s�����Z=�T������;�3'K�k�D��4p.0�ޓ�a��-�&� ��I�:Т��{�t$6"�� �����nA<Y O������V]d��{hp���	E' �O�P؀�|-T�1�H��ׁo�V�m�g ����؍Z|(�p ��`$�5"$Jwxb��%�<���:'c����8�8(�@����ԀocK��¾��X	v����'4    �֮�����+�N�{欳�1L���750(. �c|p��aA<:�ix��d;�.�*	e�=�T?�:�#�� c^u�blU��e�W�UA�>��8�^:��&�-q�+��/@��jR���)��$�b�~u;�����t`Q˭�iن�¸GH�C�� q$��d�����cn{�ӮE�g�ܔ�j��&Y0eH`��=�����e���_Ə�Ўדg{Jr@�c����AZ��qA�C���e#<Ȥ�߭C�2�JŪ`�{���i{@Q_���ʹT��t��*�S�O~�(v$Z���@!w5��[�e�i+y�a��	��A_��)�:���`Y����ۓ�!���>J�V�ݱ	|w\IJ"�`��bX���:��d�е8cO]Щ$���5� ��n�OE����az)fd�+H���f��V��u����,jOeP}3$� �;�"��^V0��}��_�f@�����ذe>��3O��sg�r��]ΏG���]G{P�d��h�@�a{� ��Mү#@�����'��'��w:�AG9��G���Y��kH�,u����t6�<�E4�T�9R��v�e�|S�zfO��pp��,��f�Ć�s$ �@Ȏ$@@��6j��!<E\�M���b�q惹�w_v
���H�؋hr׊�9�<�P;rN� K��5s�B�Cs����^��tL������Cy
|�p�Mշ���&I��s���8{��ĵ����%/���~��1(���ڲ��$�N.H��,�+@��9��Ќq�d0�`��˰�cܷ��}�A��*���P�9�1�4�[� +������]XH�lJU�ɬIǚc%[�j^1��L��G�;C^+��8��|^�&,�~"|�9Muf����(�8�%�f�N�m����I�`���ݵ@Z5~-�g?w.~��W�i��d~yua��u 8�e~h���!�D�B��>)z�C�ԇ�y�BkX�S�a�S����)A�2��~���:�EOup�����U������{�v&���\K� � �l��X�(��<�YwY!v(�f՟�:~��c��5��i�EG�E����-`Ñ�lpT�So�Ş�d6T�Լ�O�~9ʂ?Oj��S5�	)5}*�G��~�f{�_n;�U!������a�; `# �O�8
������A_�P`l�*3@B~�f�������B�Â����	���O�ڮ�c��W��m�~G����Ab�����MVk<���L�ع�z�Ў�%�Ʊ����)�¿H4/rq�ڃ��#u���iN3���Q5�3Ͱf0o�0�4ŏ)/6Ğ�gt��Z���2+������
A�Qb�n��'�z!_���~|�r�˧�dl:�hy�i�Ck�=|�Az�p$��C�a x��ޚ_�$��@���#z=���@P�̠i���J����z>1�pB�ɶj"5�@�LS燯dj*��4_7� ����.�At�����y4y�t�Ι��	v�'`�D��u��Z
ȧ.�<w� @Q�;��
@���-5�=�F�]�3\D `��DC�����������lyj#W0*�x������0Xن4+v��w �q'^�HA;6������Q���� �3��+��բ���O`X��ZJw�)��	�.������K ��!�|�m����Gr�v�Y�v�m�M��Ԣ�3<��O���>�Jx��s�TT&{Sޜ��K��K��"D��լ�#ژ@<7��ms����չXB#	����P�w�:!�.~E�r��	�[Sˁ��-(X��/|�"�k� ;\V1���#L��pN��O����ġ�f <��:�li��x�Ez���Zin!Bb�S߸t+��:�;
@�2@9�]�jh�m�}��3��wi��4:�m��m|vLu WT�����Ô�K���a oxŃ�+`8*u:U���9�M$()�H�t�,��{P(ŷ�$��j��,��U!�A`�!�I@@�q���C��P�����&T7������=KW�Z�+���߫O�\�O9 ��v#��ƫ5��ޯ����0���y�sl�X#�r|u��Ə�����? �{�	C��A�o[���  /a7W& �A���B�!T�@���j��e|g�?���@ȱ��ГA�v��h��v��p��D��G��U����S���i����+��>���:������V!v�,�g�j,�w��pc���0~R
����z�lVSVP�cb|��;�U�L4HsV}[��C���PR���NC�/�@rU���?�_�NļQ�<��.V��]��hq�ȍ�˳G5O%ݐR�Jiv��k�{���sW�z*z�f�`@G��p�����V����`tۭ1�肋Z"!��k	��EZ���j��U�0��KM	-�-6��+eֲ�L.�<X'cUu�U"T���i�O�IL_5������j���7{�g�c��mFRQṷ"��-�
F��['� ���	$��u�C���7��W<���L�m���U����T�6� �M���)�"�}�9��v�b�w�L��<����@����a`�3j5/ܷq�'""�4�O������ 	�t�f�5,g=p���*,��T���Kb�O�[��q&K�P�Hv"�b��ѿ��m�����׃�S�&@{���{�^ݿ�m{�W�T@�2U4j�9f��U7�����
�:P�\uع�P��9M(6N]��Ø9z���I��,9�GV��\�D��	#�2��a���h{�9����ٌi
m�y��ƞ�c���{Y�29��0
�e�F��A��
��N�Tb��ب�M���7�O� ���$�����l�#H�.fN�o�^��N����=���2h�pb�.���@��9b���2qvg�F��0����߿wG�nM��b�=ƌ�j�oF�ٴf��M~�"��|oa�cw��s8e�Յ��	�Q9~r�ϯg���	��8/6 �J��i:�D��K�s�G��
>z��������{�*`��3� �S��9��غF�opx��8v�Nj�N�����?�I����gbNdė���v&v���c��9���h��]
�P�`n�%9����2OD� �;m`���|�0�C��!��A��ܷ�2� �u�@�aX��d@?p�T�T����8��DG�񎄏ex��`����x��9�p�����y"�e"¼,u�^�T�rD�'�����S�����x��EB�D�)i��t9-��G�*��\(��G��������|�Sv�^j��̣
����V���$���Ѡ#��&D	�6.�ݓ�;���X�Ԅ]MOTϟY�k�$��}\�_ɫ[�����g����0٢�%M �Q��N�k:��uw���_�����]k��;�@{��`^�y�7;�:lN8��)M�\A��s�*��T׸�p�4@o�i���D��/�r|�ʺ����{�[g���:��$/�Hg�i�������Y�[��by��[�&ᬜ�����d�t�2�}����ą|�]�����Z��v9�V�ݍu6�R�6�w�&6��"�uIwu�5��2� �3�}νx �G����Z��,��z�!��T���Ա6�����8Ҷ��tR��d��0N]�3�8p�BI
�"�D�Q:}�j�.�R��D_N�Y]���G���Ͷx�C���=�������+WPP �_�`/%���$�T�{��Q�œ$�T���A�_&����nKNeH�����nc����B#t�M�H%9t�ա ��ٜe�yoY�N@��U�
�S�6>��&��T�����N$�� �^���M�g�b�:�5��yM��4���:���ș�;�>z'��ŗ����˜�	� ��-}�q��|���z��	�U�D{����}��>;���q��\a@��̀�,�W�$,K@8�o��G�B�^�HMR�v�n�Nu
����Ӄ�n�D�6 �  ��A���w~���d��d�zE��'��qT�N")]�Ny
��Tdx�֩��5�&�Q<����N&�0�L���|��̜^�#�pV���-z�SخG�����6:�(vo�[�:=
�#V��@���8T����^�8��IN��}��S`T�Z,��z�a0V��j�^�Rxp�iu��r���ws�	D�Ф�˧�	�:�&�����_:��jt3�@��X��N�lԹJ}Y���5�N�y��)�'pp h��T%� tG��E=E�۠�\D7���h �Y;��!�R�^q���]�f�FY��j+w�N���V��D'"�yM�a�%,4�9��QO�$:>�|���}%&?��V;׊�DG�B�]cP;�%�WE�5�҅�j����-�N :V_��
��<-�)O~t5]��:��z � w3�6���gͨq�l1A��/��է���@��ՖeݼQ@���ɻ�x,;Yjp,j��i�Z��,�Tj��VM�����.|��9	Ȼ�%���P jP��\l4����;{��g=i��~�|@�g�St���е�8�~Q�`Y1��u1��i�#U��	Sx��R@��f�&��\�T�F�n��=p��Y��y�T�/�'�W��� ��l��ă�H=C���u�5�\�����O�If����o󟅏_}���Y��A@�Z3Ѡ����c�kY���.ǧ��f���O^��SP���ji�������2O0��\z4���G]���6<߯���u��<�WY$��I��`2`A?k��[�å�@U�2+�t�r�c$�ҧ�	�c?����?-TUp�L��̜0!�"�;L��ţgY��E@��L]j�5�+��.d���<�} V�}������K:�A�W��\�Î@�W�W�f��,�3�y�'�}��8��/OH�0�<t��*�Aߖ�% �n�)��bU���Mc�Q߃���������1�۠m���SU�okt��/�(��$�Wg�=" �-��.��L��?M���vm8�͓Z&ٰ�%�F;���48�m��/ɟ3P��%�F���DA���?�LP��^�ɹd}Gȡ9�^0�QwI��3�z�L�r�AC�S�L3X70afpɽ������0��kx���eJz�5N$?��Kl h�auy��{��3����62��.��>}��k-ƙt���1C?sb�l���RИycy1��Øp�Ir!����ņT���������Ӹs:�?L8�[����x�d���FcT̯Cq-���y	t �jjsd$=�� ?Ç�l�^)���Յ�sy\���Y����ҳ,��]�F!� �Q��tlBL:E&�u�����	�9�}�j[o��������I׺U�fG�8�A�;��9έւ^
�
�L��?�����U1��ܗ?��{����s7�Po>&L��}#���N�§���iz�$@eZ���~�����OrjOz���Lz����gϏ��=���v5����CP	����n�Kӥ�^�?�p~h�7��̑���t;gd(H�}�5�`��i�ѥ}��.c���C'A���u��1_>5�љ��O�C �s]s�|AkN�Y�\s���^�9�����XҙO2��I��1|p��__.p���ق4�IE�������v]d�:$X�8�UT#QX΅ΤFILh}���ꊐ���9ûGײ���bF:��Y��&�t`���s�K�9���@AH�_�ף=؄k֝�������)ːF      �      x���I�%Ir]ǎU�����/��'�X�HI%�l��z 3���>q���ʰ�>ի��ic����Q��}M��xk����l�Ѧ�L^en�W��������]��Us��zk������1#�j�ÌfG	��9�])�lK�6�j��>[�=�����o����_���[�?��Ǉ{���~���6��_�����_�o��o�u8c˿�������?l}��L	��~�����Ͽ����m�����u���I����1��em�3�n��a��W3q%|��f5qN��?F�a�1�������2�X��]&?�����y��L���]�)��?~������m����o���#`���s����������������?���_ۜ��ُ�?�yk���d��?�S�������������>��}�L.���T��RJ|�xJ^;�������T��Z6�l���T��f}��������h.۸w���s�Vv���5����.�Wy���v9>n��^���wGw
?-d3��{/��S.�9���n��M�|���Y&!������l9�x����e���Ξ�aV��}�&��a��>�K.�ۼ���a�yY�z�|wtg���B�A��_ˌ=�|��m����X�h(�#χ���	����ʹ%ΆmS$2.���Z��@d��mӴFl�e�-��aŏ ����A?~ZǙ���5�2,�_��1��b3��0�.�����X�6��1g�=�Ke�e��:KО��:j\q�S���e�L��ێ�a�^�ؚ�wGw�?-�g��m�c�mFƛ�@�
��{uì`z����������D�a��N\�}��1�|���e��Yː���s褴����m��iJ������wGw*?-�	r�%��ji�5kLja��&���+h�����sx2���<?�ڊ(ޤ�h@�f[-xk%"�����K$Do7�!��	��-�?�y�L(|srg���>.#�فL�IiS	��_����ٺ�3xh���Wߑp��bܩ�RL�^?/�
*�*�T{jitcB��D��$��1:��J>��;����'��(���	�.㍩����vݭ>����i��q`ƛ�q��t6��5+\(��H���	���2Y2c���m���%�i�.�xڅʇ�+Ѽ�����D���:��o��R-̸�ﰺ#<��X�/������0�d� y%~�X�B�_&�P !������ܪ!����W�i	�z��O�����~X��!��ݚ�B��v�Y��;a/��(.@zk���4�ĽHW�+�r$ѵ`�Uc��f��ݒ����F�g~��#�	�n��][sDܬ>��X������wG�&�0ꍐ���\����"P�&l�X�u5c
����F�1�8R8S�cL��Ƃ��n]O+�����V_6>
g��g7
,J���������՟Ont!Ԯ�Ի���P��Fۮ�4{�:V�@~�=���1�ߡ���ݒ���U��מ�A��F��7�>��Am�������0��ä�)9���ѭ�.���u�Ԗ�k�}DI+������"�%>�#�@����H��Bui#ǁ��t#c�Q\9�5 =�e=E�nbո����h>����WR���ztk��8̖H%@3sZn��,�3�(h >�P��˻mR?������"0V+�hBs�V䮳����+![+���'�ϒ��1���i�rtk���6�a{$�R�|�a���7��'��f'�&���6�m�}Y ��2�E�C�{����j,3��#A�:�z��w���Yș޺���҇�<#)c����Db="��@�ï]�-J�raI�`��+��)�.dnB�%�S��=�F��c\�V������]39�I��D�׵T^�QV���UH0oqv9�5ЅY��'i���`{{���(d��JZ�D=�x��23�PZ޸
��Z��	o�����%� �c8�'���y戂k��s�9	����\x%���ݙ�]�u��/�_�O:�l�W�ctR]it*���~
c�p������hx~/��k�!;ē �h����d3@�pNPL宏���n_�[ƿݚ�¬q�ܘ�9p��r���+��z�oCE��}��!>�������%u�S!fs��M qX"����"\6� ;H�{>�b|���E��<�5хY��+W��:|�"e{(�#*�T~���Js��N:n Y����c�[��S7�Nwtu�_��= :x��"Z�H���ެ��(�
�%k�wG�&�0k�HҌ�+��U�
S�:8Z��,��I��9Xs.y�c����h�\dѻpr��4	�.��<�c���I2�(=̬��/� ��^����DWn��DP����ia�B�Fn � ϭ��Nn+6#�;������*�(�WT�J��h~"�C�b�^���R�Z�e
�<�܁��|��ݚ�­�	��A0$��k�:��šp���:�QC�G�MP�8�����%>~o�-xY�3,<������sf�����Pf�v?�ѰC(/]�����ѭ�.�ݝG����� �����LPv�e�7{x�s5n�����#�\��Pݤ��R0h�Ʃ�2A�.F�óPs�H�k%��l�6QPf/�yc�;�5х[�Q<
�;�[�s;�*���%<I�Lfu�Q뫭�m�+@k@e�8Ӧ��K�Qx�9�k"�Z�ۙ��Z��slX�k����+:���l�]�nMt��M1Q��V+D��:��2n�j��<�|.���Ye�F�.&��꫸ED݊��R�,��%ևY�2\t:�A��[}�Y;��_'d�wG�&��k;�\N�B��7���1��s���D�Y�������rD��C�"��6�IA��i7:>ۄ��zI]@�� K��N
���M�a�O4���-ЮG���v[���<�@8ATq�BZw0!��D���6��v+q�њ�D�ɖK!b�ζVغ����ܣ�ۮ4]�N��x$�D�ևٵ�P^5��e�?�nMt�k��0`Q��aC�q�b�,O���h�,	8�ؓ�j�9L��Ii�Ѱ,*�A�f�����e��I�Nɹ�S5����q�.��2	"�����D,ZF�i����=`�����V����-��"���/�'�|���w�b���;�;�p�n��g�޺%
����e&����	tz�D`r�h�oNn�.��1�������s�fg�[1�l�<�C��ht6y�R�&��v�H�ۍ�GW��m�|��5�<�G�ڥ*)���P)������#z�W�����Dnm�����[�|�R�L��/���( 8\ �Ɵ��E 6&Z��Sz���f����`&�5݄/t�T��vB�,���)�y�:-��_�\���ѭ��ܚ��Qym��v�%J�** �)ZP(�TC��9�N�A��G����42~*!��q���B��vD�>�b���U2�7eX�m�5��0��mM�+X:�5��窫��%lE��B�'��bS������v�˟�=s��v��6<Ç���D��f�^�㔸j�����=�8�����M�_!#ľ�}:�-'�^�,�i�Ng��4K�F-��:!:X��H�T<r]/�9*�m\Mu�X�|FbCO^K�Y~�p��+\2�6O�a�g_��P��9~:��gקꮢ(r0���P
|H�7�3�&3�
�
C��Iz�٤��!�HM�S�z��k�\r��c&@�j�Hd� M�K���$���؋\�0�h"��bѧ�[}z�pVg��|�5 (0�Y+�h�A0Ř��J�~���zeۘȒ� Sȁ�U��%��t��QAm�T�#�#��XHn�G?�E����3Τ7�=�5�EĖmjk��I�����g�S��a� �`C���NԸO�%wZ�ARZM�Ͽ-8�q�d]O,�[Wa�*_��춐T$l��in]t�Q�������-\_�fTQ6�� Bm��yl/�Ԗ��=�\t	 n!L�    U�Q��<罫n�Tp
�"�a^=���*5�[t5B��"�����W���E?�n��b�	r�+@�ٸ*��j�^/�?E���cI�֑�Y0
��|TߊI����Щ����7���q?s�ҁ�*�1+�o!L���� ����G�&��5l98}�5�^k�n4H�1/�YP����,s�4;Rҿ�S���a	�F�m(av:���fSMu��ȬRT�<z�oQ*>���;�q �W��x����Dײ�Z��.9���%��p��)��6���מ$!���q!;i��5�j�*v�+ݡB�c�W��$�'�lA�H����cC��
����C#�=�f0�k�}:��닉��;��z�%�Ϊ��F>$�Cf��z�����W	� ;�^8:��R��t�6��vul�X��������*�ɀ-(x���M�=����T�C�}wtk��F!Z��8Dr��Z:�ːk݅D�Ju�hQRz�s�0��ŊK"�����O1h�&�,��r��W�_��+51�H4����*�-y��Z�zt�ѮW!s�DШq�X�F�G�<Ʃ�,������c�!PY�Ĥ��cǜ�Te_�ze�d��� �e�'t�ʪ�*?c"�v;x,G~[Ok4V��o��ѭ�.ײq����tM~�Rr_��c��\����Ȝ�8l3U[��� ���n�Zr�i-����$��1�ѝF5(�U<��f*�Ƈo���/��$�Ջ>�ڵ�#��p���t���.�mY�>u�%@��n�|���E�>#[�[�#�6R
]<Ѝ���:�x,��*��j�hn�}����(=1wtk�kQ:a2vu�BCV**��m?I��P�ŏ[=� �0A��/ҫ�����
�^�DpJ�g=��w��:ORe=kr��wyZ�T�I�������6��U��F�%w޶O�zcK���H�4��L�!ugr6(�4,� ӳ����"n�SJ�^�C&Yr#��J��b���-�\��>\��y���W&�ytk�K���ד�Y�ѕ���q�2зս>:�Ȋ2�a���L�6>���������F�n�WX�P͕1qT�k�� ,ϫq~�3�y/��U ��M�^�nM��ODCw���R��qAP�Y-��4w^�����'*Iu��k�9��ȫ�46y�6���I1�BL6�$2�?����f�	�|ŢOG���Sc���I��|�E�>�����cF�
���S�&�#L��V!Mã���$;�k5����j�����d�[4�0d��J�^�h�>-@��j��ۭ����D��6*��صA�U�1��rk�ϴT�F��{'C��#��kT���Q�n#WA�S���Y1Rh��g͘�։�ԓ�$i�t)h�ꍖJ|���ѭ�.w���AӔ����L���A!UVǩR>4��j�T�*�U��������g���L�AŦAAH������.?�ڋ���������D,�Ԑ�3N�W��Mef�]3u�Z���=0�)�=Ņsų�	Io��|��./d��S�6T��~E@`�����ǚgkn��MˋP2�-ЮG�&������M.o8��&tM�J��ب��0jL7C8� $�h�ij�(�h�<�չO=����V�̮.���?�m(��g�O��/׽YH_o?ݚ�ZbIi"G��eu">�LP'˚vz�٣Hc=o:&�[fE��܎��q)��xt@�5����x��G�mY�|��W�nʟ��<����J�|�hףۮ�˭����E<Ic���2��F��u�#���ωf7n �]׃�\��rB�8�c�!a<���x��(%����!7P1���l�������ؗ��[ѧ�[]o䶙�7��L��>�MۘIQ0B���*9�������5Mo#��(����J'�G~T��»X��X�n$; ��	�p}��Hv�jZ�oI��ѭ�.�D|��goTбG���4
ȯ�)<�0Jr3F_<�7��*`�TwR�tb�nzEJ�"O��������ί5����^MF�=n"2��%�פ����D��&i�@����D���t�hA��KW7���(�2�Y��k��1kA�T�c@���Q���U��2�Bl�g��6�Um�n�_����[]�un4�b�����P� �DW���&�X=ơ;��F��h�P6S�����;��]��w!����=�\��eW�?(��cT���fk����OG�&������a��ڜ�����)е�(��Ԝ6�C�[�&�2I�5�q�\���$��w��ث�)��.]b�G�t2[+(=m"W^P����OG�&JW^�4t_^c@�1��{�q��:kt�I��v�*�/a��U<?�>;(����ě����f����N�mZ)�O�]�!��4�
mjzâ�ѭ��5�Dr몠�L�Yc�p�DvV�k,e�XV��J^%��
�F3ڣ��D<�ίZ�#��SѮf��6�ݍ��3��[� u���qE�*���ѮG�&�v4�lP[]B3qQ:t�ȃ@[T�*،������wnC�hI%I[�4�g8�H�X�.��1Y�R'=��'f{Qa?����p�L(z(4$��]�nMta���O�8 ^�	���>�r��V�9�I�F��!�!��} �:R����Ξ4o���5�t�Z�Ԡ�bk!�&��7��Ʒ��OG�y.������m@l� [Rʡ#q�
D������r�F�V3�C�B��Z��UT��ή#RTq�G�U`k9_�а5��?���WQ��ːOG�&���}p�gC�筵��7��W�XȀ�@4	�)�R�n�0�Hu�x�9"~V�et�H�>��8��U�VTPE�3��<\��|}�-�s����@�,o�U,(R�V7�9��7�46L ��gc5����|�"�th��nc�w�'�+#G��_dvQ�3��oZ"!�V�+=l���틠(o5j��nMt��W��x>�ޢ�2Xq�9�tv����
�d�)���A���&ͼګ�m!���b�M�z��A�0.��3}6C%b��<�в�=k��;�5х[C�j���66��J�������Q�dz��.��QXI�	ӄ��t��&?��������ơ�X�x���|��Kq�6�qh}:埅h���D����Dnm�yl���O�0�?M5̾��2z�\�꽯m�@\�ND����O�o>X,�c.�����gu��$WLkt������c�0�UcqoE��nMt��^�6�y,]���r �/�/�����k�m�_eU���	CRۡ7G򡺄��9�U�:p��'���L�՗�7�z�]�O��P�Ϗ�șW�E�[ʿݚ�­E=�*}��D$'=���!�F$�m�]aG�h��v���:\+�sY4G���u�81 Ovl��	�A�a���ZO������[�uNᗣ�)sV�ɿ1�u�vQ�i�QcME:���9Oo�Z��y/[4�),�MZ�.��\,��Pk��cy��KW���|�Q��E��G�A����>&BQ�wG�&��us.aP:����VY�r3n���$"I��,�� ����EAl(8� 
�jX�FB�d��^W �V���-��qg��j�a%�
�>|��_�nMt���@�5�� 1��&c�ܩG�Ql2��
�D�؀�_���Β�4�N``����ua����*N�F���O�o��J�Ҟ�"Җi�ė�/G�&�(4Ռ�c�՘QT��%��X�ܛKG��#��_H~=�3���.�3�36�дP�5&%OrW5YtϾ5O ¾�d�G����V�0Kt����9^�5T��fW��Նs�0���sg~ ����g�|n�4t`"`�F58�ھ�*��N�z�����7Q�:�Գ���g{��9�(��K5���zto��e�'�,���3蒚t��~���[M�*oly���l"x���Nc�̱���]$k�3T��m���d1�lV�Y������}|�_�r����׹3_�n���D�c{���ݘ�5A���(��ց#���    ���*P�TZA�o�_ft��~��ԴWY�Hsl|^��f�oΪ��-���s��0���-�<5~9�5ѧ�X�.A�c{�P�U5�d��¹�z!W�6�;Bu��;�}�m��&�49�rmԨ���Y]݀���
������H1(l����<��N|}��6$�vέ�.�9)��A�Y���cCm��E�Mh|���ªG3�Q��D����u�i��wp�nwI�\V��@��^��l�>f��&M�_�|9�5хi�g�^$�l�N�R#3W�sQ��Z��sƌZ��J��g�В�
(����`=R�������N�[��Л�B"��r,#�q�`�{��ף[]Ȁ���ڬ�DL�:���T��;W�J8��	�v#CF��=6��F͈	�i�gܦ{M��Xc7dnH�������ə��x-�p��߂����+XE�pi�v��5"*���J���#.`��k4�lhT�
=���}8�u�kV�t�"U�Vh�:D-�y��s�G5��f�׹�_��s�%�f�Z��V4p?k5!>�C�0J�W�@���	�U|�z� n[U#�:~�ԁ.�x���n|��:��il���m5[S���V ������w��ѽ�.7F�b4��:7D�;b3I���*߃p04�aN�k%���a^]��̑���06��aE��u�TO����.֝��4���p�٪'W�P�_Uڧ�[4�\�5�:˦F�qkm�$��]t���n7-ge�S�CJ@}L��9�,@�gΥ^5���'��|��V9�E�l�Fu˺�s��/CD|����D��޳P^qC��;�]6ҹ(�N��v�[�(��NK)�6��Y��f�cRwv[ak���,3�^,4���d���>� �q%�7��ݚ�h}Ũy�X��v�H��l�{8��F�"S}�m!�4��R�zd�
z��u�Pb�	��FӉ� �4�ށI0k��Z����h>��c|��6�1���mN�>A�9 fu����e�L�?BJ9�s���|��wf>阄M?l�~W=p��t�Vu�J�z�TI�Z�������UP�� v��if��b/͚�o�!ף[]{cI�i����"�3��%���TC��ך��%Ė^|�s4�O#�lz�*��hf������۪:ݝC���+�Ǫı��ї�7gN��RzK�ף[]��,��\}�fV�N�A���I�iZL��������&�X\���4h��2�|���[�DP� �ٶ�U��j�d�������9�Q�ϟ��ѭ��#5٘\߈�{\Iѓ��1���Nt-��QQL
Z�@v��3���*�ΝpM�w=Upp���YV�H¿O0��1"��OcQ=Մ�f���=12���b�8���W�K$.�A�Vk�Ԑ��UBk��uWA'=�f�e��j�W�*4T]u�M�IY ��T�!;x-(
��s��*�׌g}{v�֪��mtmڛ�y���u`��;���%�ƕ�4d�kьxe��#�R���H{�g���ѻ4T��&x�5�h���h��2zD�j�����.�8���9�R����F�;�n�k��ai���P��L�
S5x�v����|��TD���[��>��k�d:_=���6�v���6�RZ-䀖��g�/-��"��5�>���r�v>|��� Ӗ�� �@K��]P�#�2��W��Z�E�qt�(�������G�娑+d�	 +¥ԋ�� �8Ω�*�yX�������q_�n��u�C���k���~k[esz&ԋ���H�����Y4������pL���>Zå�۹�zGo���k0��S�/���wZ��C����y޸����D���ޗ��?,��4ˇ��;Tל��D ����#1Tۯ�*}�ct�����z�o/na��]H�8S�#�TH��5v��ir���Qxiez�iף[]n�B�ff�M���-� J.e��B��fwr�����q�9�F��h9���L3��4򹗭b�*u�_m��i�Z���OD2�3�G_��CP�r��Q�;��FW�O��*�!h���Ӵ��e37lU`���s���F��ؒGhM��V�a�s��@�j�O/uĕJDq lϝb�\�s+�=���+G��}wt�����f\�H�=�UGUCy����=�+2J�4���j8'��E����a"��8[f\j*�8;�]��̲ȓ�l��f�d@��2#�!0j���kN�tto�kM��-?�kh��ݲ�/�͝z퍟U��=AK<�(w���5=���msZ����tF]���k�ό�w�W�[�Q�vy�5����+�8���ڧ�[4��}M�'!���[�Eޣo��ԕ�Jԡb�8�ٹ�����QU5iI�b�f��o��FkqO���I��*�<���"1���J-jʥ�q�*�~�/"��_4`��I�Bk�}(52����^܉ޤj@북�����ⲙAe���A(�B�������j�hS���e��k%����G���]ont=�����В咰��5q푵�m-���~vm�2�xS5�S-U�-#2�$�A���q+k��kv�� �����o����M�}v�?7��/��7]��m��FĪ�2���"b�l��R����Z�,4H�̭������ ���y(�������8�l+QYt�&�,�Ĉ�:J��.�������YGy��ף{]�<8HX� ��:�����#HD���8��g<�qG�|�>�蚟Zd���V�h�,����qm�[5�Kw*ps�82�4dWi6ԯr��ѽ�.oj;�	�PHIhu�TJc6�:���=MM��t�1����QA�J�{i���V��ZR�Da���yk�����!%��+j�!V�-<L���[���U�|:����RE?��i�Ե���95m�T�B hE�����������]�&�]�1jMc�1UgkZs�Z^# Wв45_i@x.��_Tb4_�$|����Fץ�$g�����&��B�%m�NS���蒕��α�S�}S]0���]��k������v(�a�8��q�3f�������$/��\�\����ZA�����hT�=�~mPڕI��#����cih��G�5p�P�"?Mm��4̦����	N[wšH�A�H��/E8�������pf�k���ѽ����E��eI���:Y-$� �z��v�ݲzi�.Έd��v��#�B��M���k�Sӣш�͓f����%p0[w�;k��&ŧcM��/�9����{]xv�SW��F6h��6��#�F�$�^p�U��l��Q�0�Fd���p5aq�l�ʏ	1s9Œ�T��ֹ��)Ɩæ6#�s��!��_1�x-�z?��f}��1�k�9�9�k�D�|<����+V�jXl%8�A�U?Q��<{ ~�f��:��v�6�Mc��د!��ҫ%]/��a)I�4yT�����{]��!R��	'�.:<�c!��mB
��>�,��۩֖��pY^�kꕵ��DT�����j�D���<��?����}$�8v����a�X_Ɗ�|wto��-��Ǯ�2(>��리����PuGQ7�H�����H�:bM��if���<�f�� L��Vv�"��vRi?J�kݥ=KoV~�F��hʵ�����F�^G��%�Z�{6����p��M9�]qM�I5�cT�q�����Q������#��:��v���~ij��+\n�&��g�����D�0D��s-o~t=��ѵv��e�k2�2m��*xĽ��;i]z�:�
TPcEw�|�<�C��q!=�Qz�aVF/����PS�A�ik �5�LIs�����a�+�7��Ծ���:�o�^�;r1����JլP2�Aď.�L�%u	v��K��m1y�޽:�Ԍ�F�S˰���)^��9~0���6�/��t�"�G�6�>� �}�H�5������h~kļQݕS��]�$�6�P�G�ٜc°AC����69T1T\��NS�&�s��< �:K����!B}9��    ��!�G�6���S8]
z�n3t�X�xF��5�w(���x�P页�|#u�/.�P�a�y��#���=�ؖQ'����T�Ѹ���G���!�P|C��Fף{]x6�c��D���v�.QKu���"������!Pε|�P�#�dĠ'0���`�-"OpL�4��C�&F+��� ���㹿�ي`��zto��4�ѥ2�6��g@�U5@���)t����>��=�_.��rƭc��5��&æ97��|�B˼s�u�^�+�Z"�i����B+��"E5Pݚ�r����F�%�N�R�k��f�vj�\+q�1�ᙋ�IC{#�v�i羋:���t��`�n��^,����^�J������N+�+JSj�sl?Q��3�P�������FW��47N�4�aVvh�K�K+v!5��(�������Y��м�%�¥��N]{8����V�1�a����ń����Ͻ��a��^*2x�kף{]xv�POe+���';��2NK�jm��+�?t���O�K�:��#�s ��b�&��U�����kz�s��,á���eUk�����N�?A��$�_��ϣ{]x6����X�4��l�8k��&ii�<Υ陮���jU�S@���.S���s��8��Y�3(�4�rK�4�D���y]�ɱ+�!���U4ǯw#���mt��"'k�C3=i�Zi1d; ̆^�������K=k��jp=�}�M7o���GU��x��LͶՐ���S¢�o=�A5��6r�׻��}=��е�V�g$�^t�[�2�N�h�agF�Z��+�u��28�n�]Z;\�>b-¾T�K��i�0Y�],����I�GV�tqS��A���6�}���tto�t}�ߚU�ת�'����#�˚#��,WFײs��Q҂T��6R�c�(0D�Rc�c�"0 g@9�zbu��5���<�
"l?G$��p�V�>8��F���mt�\�ݺ�j� bå�2�b#g]������) i���h	�
���[J�0r�ı��p^Vn�\+�ୀ4<�A�9m��\��C�s��l���ztk��b�j�X��j�F�Ԧ-p�p!{�g�d�x{��6q����Q�\��/�_D���i�vi��/����e�����Ό2����g�0Dռ�y2_Y���{]�j�W��2Ԏj� �&�Gs,�l���%�$J��\��Z�9\;�,��f���/�T�qlk������j�(l���*"NCD�)=9�R��ѧ�[]���Њ����m=��6���G�:�+�K!Ԣ�� V�`(}�`mc#���n�N�[S���ҴB���]�$f�ĀH�GF茧c-ZQ ��X�*�OG�6�4����Ը�W�"WD:��[���5�6 <�)�7�]�%	HS���t@�)s���ݒӣdM9�M�5���k���9�j���Ù?�so ����zto��5}�A�R=��5S[O��a,u�t5��ھ�����\*�V8�[���\����rb��I��<����=��L���<W���!��!������E�*#Y+2B0��ٗ����F�ց�f Dqy�P�5�"��M�h|fU�,;��U��]�E�6�~AcX��Oj6x��� �X�P�q�(qi��ח�OG�6���В<�N�q��*�+y=��ik��Mj�)���[�\od��ơ�O@]��Dt�@��4$ZE�%�	Â#i�	Ѷ��%�9��z��m�8&�P߼�ztύ�{�rK�Z�:��՘�5C�߉�wXV�r�ʒ�LU/(3���j���e,*2RS���65Y.� ��L�p��5�G^�_�<g�G��>ћ����O�wQ��4R��ɩ����,3I��*L^pB�{��x��fB'5�l�
Y�H��Ʉ�_�U��4hW�;e4�6ƥ�6��E9?ͱU�����{]򾅢dM��z�ם��P�ڧ�}Pz"��i*dV�Nc�\rdA|A��0�����m�(UԊ&�{uT�Gwˮ9�Qү���w�d�"�!�KoZ�zto�K�7iUg 1�x����Z-�g��Y�Wq��I�f-��hv��u�I��W[5��L^�@,]]����� ���	 4��]��<�����R|��ף{]��Fp$p>�&�tTC�C��C�㶩DϿ�>\~Mu��p^�np$՛j��F��i�v��:��ӑ$ǜإ�h�s��,5"��Qx�c{��H��W�OG�6�N`p�>��M��NI�4t�L)/�,��7���HbZG U�T���﹪�&L�bP	�v�."���Ԍ20l&Ghw}lȚ�p�Es.ڭJ	���K�A�	6�.��|����do4�8wt�s>�V��\]gnE+��3���n;=f�\{�bP��Q��v���X��&Ӑ(V^��z��H;/̫�o/"���mt��>d�Z�D���m��:��|J�כ�&�Ԁ�Z�R�)��7����#l|3�N$����x����9z��k��9x��v�����L��!�6]y��E��ѽ����}8[9��;�Mk��J
K|��;�m���w$��8k�QzUW��e ��]r�P��������i�sՌ��t���b���V�1�L�|��ף{�}y!�jŬr�����ԧz�4�? G�{ŦwG�FS��*^[�ʡf���-��ރToa�E�7v��6 dmd��r�|�o�������8(�;Ͼ���zO���G��Z�-#0l�x�QCj��ш���Q�(W��}?�uN%�3C��+o�'K�-�����R�9V�<׃O�qw�_�ǵ��/+��-����F׭��h�&�䬂�t�vRm�b~��u���E�EŞ/�O=t�����55[���c�����Gm�i�,��Դ$����?�i]���^���^�]5m�-����#�:Ճ��m|�wFem\�r�[-��-��4ä���Z-�Q�m �Z�N�"n��^��gԈm��p�����犙��F_���ѽ]�� ��]����pvnF����j��^�F��AӝV5��>f�x�*�G���ͽ�at�O©T�8���E�GwMk��p���^���9����Fݿ$c	!�:�S�v4{�ћ=̪�5�#7�VWV֨ЭF+����˟��W0���7��nt�+�uO0�J��ku�M����<��Q�߱y�Gף{�}�����,�Vz�fU��f5��V��~C��T%kS�EOEJ� @�i�\���YTMZ��5�i��<�����J�?E�y����^����FW<�0DM���c���`���'�%�/�X�����)(�T���F�`M�p���Ф#��w*666[��wĴ�A���X�
��:���Է�uVͿ���=����>~g�F���.�P�NO��tG�a��*��K��?&"ϟDJ=�ڈcО��Z�T���vԓ���ǩ�bFU��=�`�FJ�	zjz�C����F�/'��x���Y��|th�+�����y:�1�[#�W�a-7�t=Q����HV=<h�+����.���ElZ�� �i<��ww�9�\~��X6� �|}��tti׭����Κ���jFC��*ܷ*�A���*.x�V5����cD��m����M�*�����U��4q�F�K��j&�9Q/�������*o����yt�G��Z�lz���*�p�����R0�3^�x�T`U���a�}�l@�j��tPp��^o)��T��I�]U��]tZQ;�O��X��ּ��_O�-t�t��ː��[Kd����������j���h���ef��S��i��ǆ�]�Y���9�.�bj�+��Vѩ��7�1[�𴞵j�����rpo�˻ڄѬ+.b��2�I�A�R�M��7w���n�dޜ�W�F��)���v��b8P#/�qض&�K@�"�*�OK�����Į�D�o�ף{]���5IBҗ��) �^����g>E����i�#�9�|���T|Fe��O͟�];�|rf���hc�K��:R�.�r<̋��2�R��q����__��VS�[��s4m\"/�Y̡:c𜰰�"r�Hw2������ �  c��j��w�4�>�U��̃F�k�
��5�,���a�M�~Z����{�Ͱ|}�ttk��GU[�oV�=[�W���Nj-�
�!X�F�L5���3j��9�vu9�{�^��jhҲ�A��g��[Re�vkj9"���0��N��(��6Y-a
廣{]��9t�|f���J*��6M[���8u�O�� �j�J��J{���ڨAB� ��M�mm]$etIP��N&�Z[�U���_,	l�2�y9��>W�=���u��d�WP��k���"�q�!8�$�����!�
H�&��Uy���8��b9�����#`�fP*��lS��
Wo�9I+�30���\y��}�����Z�m�d���'�8i{i��VL������j����hh��C�U�v�Vp���ƺ �aŭ\W�D2�����VQ$���3�>ډ-C����p�{]�C ���Ч�A�X�t
��"��rn���P�Nk3tM8�ci�J�:j�~^�DH�0�Q��S�U�~x��"0ի���gmT4e�9-�����Fש��͏˻o���x�C��I-[V�rH�ZF��F�zK�����MX����h�l�ݮ�q�"�צ9R1҉*4�/ktn@���}�A�b���zto�?R7�)� ^S׼̤⡌@WQ�"��	�tc�'�k�!:_�Ds�{��΅aeI�����"L7h���1N�A���D`�g¼w|pq����f���Gף{]Ԭ�Cw���&��~�7��O�ډ-fg]_k��Pᙤ/Lk�/+j��T��S6	�ǆ:N��O[K��;�J	٢9-�A�jV�����������F�֨��G�5멨�(埵}��}j뷢Qs
�aFsD�ʃl��2Q��j��3ĥ���=4��ăឍ�j�Z^������C�J@��^��ѽ�.7G���&�V�V�)��:���`�[�U?�rI!$+ǚj.	� �f�4��+jcpŮ7�daTX���f(	j��wƨ��>k�h>Lz�$�gE����F��$?>�]�Jo�t�k	-�IM6�*?5l,�����/�ɲyd-;�k.�}�Y����3���	QD���{Z�3@�w ��x�!lxUUL}��OG�6���^�*�s�h��jӡ���l;��hcԤC-݉y ��k���mdp|ē�|���H��U���ګi�0J
,��F�Ox���>y/��N�9��x����F׻��ԜeU����B��#��nm���آ&�fc@�̬�X\�t��x�K��[~�n������D��(΢���S���-��Oލ�0��/�͗��G�6���.s2�������aF�J����8�9�	�j������>�#CՁT�D�4U־]K(|�
,`��dj��޳k�@Ӄ&����P���kף{]ש�bF����T�� rqڐY�V���]{D��<�&E�/֣������#���.�x�Y�.ZȖ&��Z�\Y@VB�Yx
?ִzҞ��<����³3�;����9<r��^E�&�>�'�F���J�ǎ�n! �N5��̞�V��eΕ�(6o��L�����7���6���
���mt���-������!Q�U��[�\���h���|B����ѽ��U̘�+Țh0�eh��n��Q�\}X�<�t��xZZ����Ӣ����ף{��}�@�A	����Y���JcÄ�h#��`t�4_]�آ-+���,�0��ϭfU eZw��$�#��H�����˗��̧m��KZ���F?��mt��M�
  �ECH��a;XUI;�0�=m��}M�IC���C��Ҭ��O���9�(���	�C�mX�Q�5��7>;	;���zZ��y?B�j�����tto�ώ��+�Ԙ@[�i׵j�a�UO��(X�a59�� ���B�3��C�� #p;FW5qM��C�juwЌ;=��s@�u�@��m����?��ڨ^xvܸ��0Q�{�3�ݪ:ێ�GQ��ީ}4H�6�I�L�2)�X��8�ԏ�	�˯�N=��e���S�% Qۣ����s��|�����l�ˍ@�����Չ|�D�C�B�):�Ѯ#�O���x�Ѷ�J�`���j�A"ٶ��-Q.[C�*���v���	%�G�f��S^I�������F-��<��y���JU�����{��}67-�~+AyDF�ʱ�<4��TU�ۚ#!�����0/�!τ�U�i�)@>WC�������Y�ֆ/������>֮zm��Ñ���̇ _���G&6,&-u�0D�lp:2�+Z��
�׀�>@֓�@�J��]�*Dixe��t�������*�K/-5o~t=���u�x�+��7Z�V5h&��̵
�Klh��Fh�-�e��:�����H������ZJ�Y��J��p�ԫ���7Z�0FX�YazZ��$Hej����� �`��J:M��fL�s��	��P��R�Y��s���B�z?,9�����c6�!h��u�y��z$M�D�Z�t��*��� :���-�_��mt��$�\Cwbw��g%���u�5,��̯A�zH�\L�q��(���9��O8H-~�B���6T[E�M��wMC/S`R*Ocv����w?�����Tq4�Q�Ů{���[�=ͭ�V�H��.�iW��i^���;
@�W3�*(4ŮS�k�?����p���@ 0�6�-o@/���I^9�_��ϣ����1���;�\���҆y�z�n�T�V[��t�LJ	����m5�~��9�rvEj>K�ĜH;�\���"����5�5V�d{�2�(���۝���{]�FPX#��Gl3r��2h6�u#!ú�5i@��0��z��?�Zћt�<��;(�ViDҒ��jPN8��$�58T8 F��܂��8G�Kx�kף�X�؈��'�L+Ҝ9�H��5�-M�1k�Χ�]t�ai����++m$�@�$={/�^>h��e�g����U4��!d���#�Zl����i�&ye�{�Gף{?�`�>��t�� ��;��:fm��j�"mi�!*E�h�f=��z�}e v�CQ0ch����RkZf���.!�I�a�� ��fKxKk��{/�ܰi@6�A��[�Ո����[��u�荺�&3yP��>2��=��v�8P�R,�5��F�2�'@N;[����ܬ^��
��Fm��q/r�e��U��G�6��i�
z
J�S�cU�h�PE����W�D{��ig]�j>�B�I�T4}Zs�C���u��~ӕ>Zǣ�LP�&+t�@>�cg�󑦡�Z�����ѽ�.�G��h��$)��ke����~��1���
ށMqj "B4Rt�{�Z ��PhA�� !HF{���i�6���i#������i�����6�zt�F�X�e[X�Ēf���Yj0�I͵��ZݮVՊj��9B=\�~��R�]$8c���ՔV
z9�%@Je��`��bk&��n!]��	*{��孅}wto��mvԄ;�����7H�0B����mM׼]�C����oM>Vm��J̓<Gdƪ���%Z��sdt����T��F��N�H�<�G?�=�h�Th����F<�E�Ӛ����rȬw��'9�iMv�;/d���-IKM�.�|�	���x�I|j{����|Ѐ~B��{hEcaćn!��������<��\����BW4�ӫN��xdk|C�d��rȝJ.�g�-)�-C���ڝ�6�cb@Y�J�{R�r�.���v�r.3V�l�I;���Џ���T���{�\�~[��MF�Z������%k��WE�WU��"�CN~�H��c�J�c]�C�����z�%�T�:�m-]MJ�^�PQ��"7�����f8W��ҹ�nmt��XT��"� ����"#��3p��h�o�O㯷6w�Ck�`��y78���6�Ws��R�d�%N�kmZyS���1\�<`4wӶ�����A�֚���wGw6��׿�˿�_�6�I      �   �   x�}�KN�0���)��&%m���q��>�(B��F�X ��_�ŵ�tM�p�;�=G�yn�˗���(��o�xrK�-|�?Cp�H��
5�7(W�D�6���/+��Dރ�<e,�D`�Pp%ѭ��|������|8����V�F+�4���L͒h���җZ=��@��e0FZ��%�g��V,;������^eUU�Fy`�      �      x�3䴴43�044424�42��b���� =e      �      x������ � �      �   �  x�U�[��0D��bF<m����:�p\N��n�t\@ALt��s������墩�N����|q�M����
'�[>?)����=�+��	�7r�?7�C
�]�T��E:��Oմ�,�O���\�s8<cS]*��eC3��P�{S<�E����#�e�� �l.'�SUd`̰A��!N,5Ym"��sX%t�)Nl�É�ųSX`���v��7���#..G��͒�ŕ�O���qӼ��͋�u�G�մ�|jmCa�C����߃�o�zJ�ZQ>/B	��~��EǓ�F����\���َ}Rh�n0#A�i9��+���з������#��;G���-������0��F����`�u#�(�#)'#Go�4a���A�>��oF�����A�cs�E���h��,읺�V�$�=�Ԍ�I� ���y�BnGS�"�/cd�-gSzn5RfoB�]3�� $�[�3\o��D>l��c�Ş�[�^�ױ=��� <��X��B]�'%�g�����G��83�������c�+qh�W/����ȵ'h���S����C�Z|�[�����P�2X@iĩ��b(8ǲh�^���{��q��-��#�"�'c��u�{ђD����nG����T9��`��A�@���l���xF�|���������{��LJ��l*�^׍�{�Ut�-�O�bHw�e�ڔ�;z�W}��0�Y���nw�Ze��/���8��ګ�v������*K��      �   �  x�՗[kG��G�b-�z������O!䆣��!Ƀ��/�Hb%B�_�kגw�!V0�Cf鯺��i
�TI�Rrԟ,1v�ځ
; X� ��2�8N@�I䖤��כMZy��T�Ww׷o���_ݵͨ�O/��F�-����˛�M���뻕�`��g/����/���m�m�����՛���m�΀!4���2��]�>,�؁;����b{�:���8U���H�K��1�Dv�`�%:Y��5���|��1�h��e���������?W��h��~�~� �tb���
ؚ	R���z<C��G�����apƛ���/m{���ZY;/�~ev_<���t�����X\.А�c�@E7f���"��'�&KsXP>��㙎��|r��� �����Y81d���E���GOB��$}.ʿn���v�3Ȟyޞ� Xc��޴r��ڈ�O�@�E�/��B8d��R.��L1;���I�z�B`\P�@	�~�K���=w�����J*�TBw��D����t�Epv_���Cv$�r@�\S��	F`@9&us�w��%�	��ECu��0{Emz�#$-���vH*X�{��<��}	dP�b�,R��/�%`�9�/��AI;_ �-�XzEx��Pc�S}/]4:up�A�L�vG��nr2!$�y`I:�����/� I4|i���Ir���O������I3���K�Ipz�9}�m?7�l�AS7$R��vDl�b��F%�<-I��i��88�:]m�čD�[!u�$�j3��Ѕ&\Ћ��\0���K�ipҞ�ujq-q�8whr5���i`܈8�3B����%��^�ܧ���^̅ZuJm^��&5Q3Bom>�T�u&��̒t����w�~`�X�G-ڌ|nБ*%,�����0��:_�X}hI:ν�D���R5Zv�)V(P	��X�f�fap"1���4(߻J(K��K]_�{K��4 ���=���D1?�N��w���9;;�"'t�      �      x������ � �      �      x������ � �      �   g   x�}���0Dѳ�b�50�kI�u�����/�hc��Q�;8�4/إ�֘˵a�!�=VĬ}��gY����졟��c��z?h,�؃�$w�/�+�      �   �  x��[�r7}���U��O��Ѹ�)^���z+�ǮT�h��K�C�,{�~�h0�����i��9�F_�Q�l}t&8Ϟ�誮?ONO��g��庞�1��v=[�O��7��麞��y}Fh �<�0�8���.[�`я�x������?&}�Q=J���͓ݏy�d������&T>�wEK zi��	�a�q�L��5��`}AA2�H����&����CB����B��(:�#jDct�� ��`.����\ɣT�1dmQ�D)B����ʺP�)���CM�i�m��l\e�GSr���F��O��r�}k���\
C_1z�ԔL�L�>�A��8���"���X�e��t &��,��FM4H|E��!ڀ�h:�EW̢���Sov��)����H�B���������$|r��ʄ�)�9;�j���f[[�8e�Gp����N(�7�3��ڀ���U��J��L�8U�'Dr�'	���ľ"/9����)J3{���D�?�3��P�#��P.$�dwc/S]��`TJ30���&�T�BP�mc��_}]�$�Y#�`����o���R���&�H��R��`ܐ*��A�)�C�gp��n1���A�:�>8'�̓U���� Mv�$X���@W*1��nX�6`T�J���3aѫR�%�^��+��	�Zg�l����+���bULN4�f*ԕ����Ϡ���QU*7S���$���IE]��%�,�y��*G�*i��U�ac�FB��ӥ��s t�2@���l��kb���QE]�$���HC�����[9�BI���t���
�ZE�y�44�j��6']����d�L^&����Z�<�I�1C�U��*�t6���^zUL*���jE�D!U�T0�\+'�L�H&4��{��j%�F�d�B�c�Z!��g�>�ښ�4�Tu��(]Q0hy�S�Za� �m��`�OѨS��PH�`�����b��8]��vг����n��>�0#H�f�B��[�d40���mD�na�����I�Go�6�������C�!�}��n��L6M�#�LK��ry�ղ9��d�Sorx����n�v'e�wMWDz���acB⛑v�R2��U��"F�T� %-�l5��z<���L$�v3;�OO?|�������>��������]m65�hd�R�5����-F���Nҋ��É�Gh��]��V����_���g7��_~w��eAZYK�#��31KK����刨��J�6�h�¶�[����jY/���|q����̝<�=���������5�����'×��tu��?]'l��Ģ�f���SK�V�G�Qv=n�zܓ�wᰐ��ʹ���u9�8��ӯ�~�����o߿����w��	`eb�/E���$������h<�q=�stg<V���}� ���>�]�ۗ^i��D�ܝFv� mJ(n�$�)�>1lqH
��g˅h��w��b�P��K�����F�������7�.���9]��p�,So����e~>;�+_}�����W'o/?Χ�<���]G�5�J�gw�v���<�&�A���Jx��C���D��bO�������������ׯ_��Ik"W� ���& �/���vD�+�F/���r[�N����W��ٻ���[��b��1^��Ϳ���~�u���W�k;��tm�;y@[����T�N�i�л�|������z=��u��� #���3�>�u\DY�Z��:�?���0�|���j����R:�;��,��
$cŒ���59<�5�cο�E�&&M�Q��A���~m�oco��u����j6=g�.���XN�h�-�dAdC��!'��6���6<Я��7�.q��P�
Y���939�bJ�$�Q+����z��?|1R��a�2Hs%��pΗ-h�\��s�
i���� ���*�HA��<79G��?�ɐ�	Roo��edخ�B�XN�C��O�$�t;#��#eX�+ ����`�2��ʦ��F,�F29!#��#e$|�N�e�+��Xj6X�®I&J�#���dHF�$͈w�ϰ9�+#t����8KN-���K<#��#e8�^k�csYF��ʈ�+�ʤ!N��D�8;�:NÒ�i@�ȱ�ޙYi|��=�5J�i��"pt���`��Y4iPAR�ck"HW�EG�ֈl���*��A/	@�����=�.:N�Kw��粢��t�N�km��ʦt��G�EG�H�����eV�P�\��؀�M!$�e�����H^�t���/��:��Qp�����R�%���y��tW�7�ߏבa��B��ƃ}��'7IFn�n�#u��Λ���9V�P�ܥ��I�gq�L1���#eH�&�8DF�U2
՜�C2֗M([�~{d:RGLǖl̐�j�JG�籒�*Sz�����H��8V�ɀ��;���@U�}j��	d��ٚ(�p�v3�ÆR���^7�**x�l��3Vg�	�K7�	*wё:"L����t���ӡA�^��ք��}[���8�F�0��zBQG�U:�&���H&AUY�&��q���H�$-��qqYG�U:
��X����T��}��t�
��1����(�h�JE���*�AI7��4S�v��:������ꏏ}_�>����/���('	ns�c�{ہC���oO�w�;�F2���;;t�O����H�+0�h(����W#��~vs�����M��Ϻ��`J�cA�i+�|����?��G�>�M7��7hv&i��>�L���i_�n�'͊8&�c_L���M,���b~6����xyq/D����/m�efT��5I��\����l$��1Wz�hB2���b�6�rY��[�~DV!p�	�!����;�;�Ѥ3lN��k����3��䀩�i܅�H��K�O�7�l��:�K�� �4�[C�l
����	1_��;e�Y��N�2���:�>Y}wI{�R<9�l�2K�68�rZo�9��+H�,�������z�ZL��/>�sY�!��l<��˛��j�����������͟��zǞN��Nk�!�������Tۦ`P�x�]�K&�V|$����;(������6�N���s-?��|q3]����Z�.������cu��9M�o};�g���Ԋ�� �3��L\�n�����&�-p��s��CZ�؀'��e�w)uiǉqҪY��}��˖:��q���ɓ'�wE�)      �   &   x���43�04�0�467763��4��3����� �N      �   �  x�}�Kv����*z��'A�md�I&��t��"~�W�Dzb��]�D�!�G�[d���Û�ǿ�������!��7�o�8_�/mGK�;���	e�]�J���~t��m'�N(Kr�\B��b��ӷ4�6�¢!�}�#��>A�4���f��Ĳ��A�jO�)h�PMj�i�5�����p�oi@cB-��es���h$;i@��z" (i��8\�}'hNh�z"�6g�����NP�I�8�47ZR�3����J1y2S��t�.�p�vRQ���7��lM��uO7���:=%�}��K�����zKE���f��T��n��T��*�'أ�:�82G4�'ꔊ:m%���u���":`��S�RQ����gc��R>R���W���X���1����T��3���U*�t�Do-�}YX�Gt�{�JU���g"��ݹ�a��D;���[J�ɬ�*�4�����RQ������ұ��t �n�-U��0Ee��峅�{��:������61�z�����:��No�l�SWeK��ȧ�N���[��@�#ɮ�W�O�)uzK~C\�:�8�D�e�IE��҆����^�@�|
שs:��G0J�)�j');}K�Mgi"YuZ�T�5[�[ξJE��Y�i�����G_�̎fq'���O��ڐ����]��A�@��j�:�'0rˢja�xLtv��I�W����Jf���F�Nn����'�"��f��,;Ѓ*��z��ھ�F#�y��gj5g��U�oRQ�:�5��-/�u]n��&����HI!�x�R<&z&��	\���I���eIU>P��Va�I�j�E��$�F��"^�^�)����oRQOoy�؁�]�K1H1u�;�����\��]R�J�k�[�&���nK����4!V�g��&�T�T|�eѿ��y8��~�W�������nH��s�F��N���[���Q�Q���|<�Mvҟ������l�!��Kô�˝T�~R;��q�ϥ�M���N*jN*R�h5�T���q�� �2�N'U�G�{�1Wb;�m'�'�Pvy��K�Ә�ǫ��TT�T
(Z�h�KaJ�хm���cr*�@�U\�AŘ����w��6��4���r.E����<����'����V,�}��N�*�M*�fx�5U�2��-5&�c.F��Q�@i�v׫T��Y��C,��{%8�����B�����:F�C�2����]��S�F�
gذ�}�;��IA��o����ƬQ#ܚ�R�=a]�b�db�G���Wm��uD�-_]��Ng)R�P��P�@���h}KE��B��r���;
�'u:��u��	�Vo��o�*u:ˬg9v���-:~��s�JE��B ��*c�(w�n����W.4ƚc���[�JE��rSDU����\*�1]��r�UԘ���EF�r�\��6^ }{/p��:}5^�`zˇI�\
K6
�|;���Y1'��kj��A~8��T�r���{�\�a~�_�&��cb�a���w�t���c����%UGZn��~JE�/*�a���.��Jh�I���M�h�����^�K�|�N��q2�+WC��0V�5�c����IE�j�1"�oG�n�����~����r��5}'�����/*#/�kPXQM�r��A�tRY8R�.���������'Uh8 3x,����[��A���������      �      x������ � �      �   C   x�3���,)I��420��50�50Q02�2��24г05��0�#�e֞�Z�]�����)�=... x�p      �   i  x�}�Ks�@���+\dk{o��f5���I|NВ�FԀ"�����!M��EWAs������f�b����ECw6���� �������`q��%�0�XR�DEAWԽB��V^F���h9���z<�Y%?��������]��o;mf:�xn�Ɖ���_�����}���|^�Rgk�n'�����6�<IP)���(��_1�1ڽ��5X6y��p_ނ�,PUDm�P����X	x�RKH�Q�@(��@��[�c!��㦖��4�����3e|x]��t1�����fӤm��.ۡ1�p"��R:ךj-@~IX�l����I@sA'�^����4�ly�pϏ�&��Н͂p������#h!�y,�����9�s$�(�~�[sܰ����t���M�Ԭ�_;XLz��T��Xx��ϧ�����M�?�P4�B<A�]�oX���&���A�ާ����햝��2���/w,���(�<7�ܲ-0�D�ءgv���P��K;�fs�M�c�㪛z��ü��`���tE�6kp_o�Iכ��v�Q<�C�,@Kdm$�D�@e�3���SD+����󹒃��{��?�Ŀ���i�H	S�c��e�t���
� �F�      �      x������ � �      �   {  x��KO�0F�̯@Y㑯��GvjU0�`�vq���3	&���{C@�
��l_��qN��.����s�M�Y�e�9���GC_�v��aō���d8?������r���չ�z���4)�G���a��.Ѧ�k-�zsݪ�r9��aU�>��nSn෗Z�~B�]��^F�>�Ü4�Vc�m.~��=�p:�e�,�a9���|�t�,��������f���	�+Z$��0�[�2�S��J�<��ִ��Q��85������Ѳ��d �e����s�8������hoqpx��3B"a��"�dE��@Id5����W[J�R	��Z�Z���+���ԛ��GY���(HV-+�d) �UROQ�L� S�d��"Ɗ�U��"��³��.g�Mo��w@'Y���>Y��?�jh��{��U�ni�ߔ}=�"x����:�aF �9�B�@B.OQV����Rd�H��rD[���Ц*�<e+�\+��9���Nx�JD*)�J+��l�i���:��XI�̛��GY�9A	(�e[M�l��0�6����|���=��Ox��im	9�=����*���g)�rĬ
�oL[��>5�.�3�<���l+բk��j��c%3�2��f?fHf#     