-- ================================================
-- Go2gether — SQL à coller dans Supabase SQL Editor
-- Supabase → SQL Editor → New query → Colle → Run
-- ================================================

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  city text,
  sport text,
  level text,
  bio text,
  avatar_url text,
  availability text[] default '{}',
  created_at timestamptz default now()
);

create table if not exists sessions (
  id uuid primary key default gen_random_uuid(),
  organizer_id uuid references profiles(id) on delete cascade,
  organizer_email text,
  organizer_name text,
  title text not null,
  sport text,
  date timestamptz,
  city text,
  location_detail text,
  distance text,
  max_spots int default 8,
  level text default 'all',
  join_mode text default 'open',
  description text,
  participants text[] default '{}',
  pending_participants text[] default '{}',
  created_at timestamptz default now()
);

create table if not exists follows (
  id uuid primary key default gen_random_uuid(),
  follower_id uuid references profiles(id) on delete cascade,
  following_id uuid references profiles(id) on delete cascade,
  created_at timestamptz default now(),
  unique(follower_id, following_id)
);

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  session_id uuid references sessions(id) on delete cascade,
  user_id uuid references profiles(id) on delete cascade,
  user_name text,
  content text not null,
  created_at timestamptz default now()
);

-- Désactiver RLS (comme PaceUp)
alter table profiles disable row level security;
alter table sessions disable row level security;
alter table follows disable row level security;
alter table messages disable row level security;

-- Bucket avatars public
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict do nothing;
