-- Create a table for Public Account
create table account (
  account_id uuid references auth.users not null,
  username text unique,
  companyName text,
  primary key (account_id),
  unique(username),
  constraint username_length check (char_length(username) >= 3)
);
alter table account
  enable row level security;
create policy "Public account are viewable by everyone." on account
  for select using (true);
create policy "Users can insert their own account." on account
  for insert with check (auth.uid() = account_id);
create policy "Users can update their own account." on account
  for update using (auth.uid() = account_id);
-- Set up Realtime!
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
commit;
alter publication supabase_realtime
  add table account;