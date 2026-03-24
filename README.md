# fjord_boot_camp

FJORD BOOT CAMP API の Ruby クライアント。ライブラリとしても CLI としても使える。

## インストール

```ruby
gem install fjord_boot_camp
```

または Gemfile に追加:

```ruby
gem "fjord_boot_camp"
```

## セットアップ

環境変数を設定:

```bash
export BOOTCAMP_URL="https://bootcamp.fjord.jp"
export BOOTCAMP_ACCESS_TOKEN="your-oauth-token"
```

## CLI で使う

```bash
# 最近の日報
fjord_boot_camp reports recent

# 日報一覧（JSON出力）
fjord_boot_camp reports list --format json --limit 10

# 日報詳細
fjord_boot_camp reports show 12345

# ユーザー一覧
fjord_boot_camp users list --target trainee

# 研修生の週次進捗レポート
fjord_boot_camp progress
fjord_boot_camp progress --week-start 2026-03-16
fjord_boot_camp progress --company-id 1

# JSON出力（AIエージェント向き）
fjord_boot_camp progress --format json
```

## ライブラリとして使う

```ruby
require "fjord_boot_camp"

FjordBootCamp.configure do |config|
  config.base_url = "https://bootcamp.fjord.jp"
  config.access_token = "your-oauth-token"
end

client = FjordBootCamp.client

# 日報
reports = client.reports.list(limit: 10)
report = client.reports.find(12345)
recent = client.reports.recent

# ユーザー
trainees = client.users.trainees
user = client.users.find(1)

# プラクティス
practices = client.practices.list

# 研修生進捗
progress = client.trainee_progresses.list
progress = client.trainee_progresses.list(week_start: "2026-03-16", company_id: 1)
```

## 開発

```bash
git clone https://github.com/fjordllc/fjord_boot_camp.git
cd fjord_boot_camp
bin/setup
bin/console
```

## License

MIT
