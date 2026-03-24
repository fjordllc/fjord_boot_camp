# frozen_string_literal: true

require 'thor'
require 'json'

module FjordBootCamp
  class CLI < Thor
    class_option :url, type: :string, desc: 'Base URL (default: $BOOTCAMP_URL or https://bootcamp.fjord.jp)'
    class_option :token, type: :string, desc: 'Access token (default: $BOOTCAMP_ACCESS_TOKEN)'
    class_option :format, type: :string, default: 'text', enum: %w[text json], desc: 'Output format'

    desc 'reports [list|show ID]', '日報を取得'
    option :user_id, type: :numeric, desc: 'ユーザーIDで絞り込み'
    option :limit, type: :numeric, desc: '取得件数'
    option :page, type: :numeric, desc: 'ページ番号'
    def reports(subcommand = 'list', id = nil)
      case subcommand
      when 'list'
        data = client.reports.list(
          user_id: options[:user_id],
          limit: options[:limit],
          page: options[:page]
        )
        if json_output?
          puts JSON.pretty_generate(data)
        else
          print_reports(data['reports'] || data)
        end
      when 'show'
        abort 'Usage: fjord_boot_camp reports show ID' unless id
        data = client.reports.find(id)
        json_output? ? puts(JSON.pretty_generate(data)) : print_report_detail(data)
      when 'recent'
        data = client.reports.recent
        if json_output?
          puts JSON.pretty_generate(data)
        else
          print_reports(data['reports'] || data)
        end
      else
        abort "Unknown subcommand: #{subcommand}. Use: list, show, recent"
      end
    end

    desc 'users [list|show ID]', 'ユーザーを取得'
    option :target, type: :string, desc: 'フィルタ (student, trainee, mentor, adviser, graduate等)'
    option :page, type: :numeric, desc: 'ページ番号'
    def users(subcommand = 'list', id = nil)
      case subcommand
      when 'list'
        data = client.users.list(target: options[:target], page: options[:page])
        if json_output?
          puts JSON.pretty_generate(data)
        else
          print_users(data['users'] || data)
        end
      when 'show'
        abort 'Usage: fjord_boot_camp users show ID' unless id
        data = client.users.find(id)
        json_output? ? puts(JSON.pretty_generate(data)) : print_user_detail(data)
      when 'trainees'
        data = client.users.trainees
        json_output? ? puts(JSON.pretty_generate(data)) : print_users(data['users'] || data)
      else
        abort "Unknown subcommand: #{subcommand}. Use: list, show, trainees"
      end
    end

    desc 'practices [list|show ID]', 'プラクティスを取得'
    def practices(subcommand = 'list', id = nil)
      case subcommand
      when 'list'
        data = client.practices.list
        json_output? ? puts(JSON.pretty_generate(data)) : print_practices(data['practices'] || data)
      when 'show'
        abort 'Usage: fjord_boot_camp practices show ID' unless id
        data = client.practices.find(id)
        puts JSON.pretty_generate(data)
      else
        abort "Unknown subcommand: #{subcommand}. Use: list, show"
      end
    end

    desc 'progress', '研修生の週次進捗レポート'
    option :week_start, type: :string, desc: '対象週の開始日 (例: 2026-03-23)'
    option :company_id, type: :numeric, desc: '企業IDで絞り込み'
    def progress
      data = client.trainee_progresses.list(
        week_start: options[:week_start],
        company_id: options[:company_id]
      )
      json_output? ? puts(JSON.pretty_generate(data)) : print_progress_report(data)
    end

    desc 'version', 'バージョンを表示'
    def version
      puts "fjord_boot_camp #{FjordBootCamp::VERSION}"
    end

    private

    def client
      config = FjordBootCamp::Configuration.new
      config.base_url = options[:url] if options[:url]
      config.access_token = options[:token] if options[:token]
      FjordBootCamp::Client.new(config)
    end

    def json_output?
      options[:format] == 'json'
    end

    def print_reports(reports)
      reports.each do |r|
        emoji = { 'positive' => '😄', 'neutral' => '😐', 'negative' => '😢' }[r['emotion']] || '📝'
        wip = r['wip'] ? ' [WIP]' : ''
        user = r.dig('user', 'longName') || r.dig('user', 'login_name') || ''
        puts "#{emoji} #{r['reportedOn']} #{r['title']}#{wip} (#{user})"
        puts "   #{r['url']}" if r['url']
      end
    end

    def print_report_detail(r)
      puts '=' * 60
      puts "📝 #{r['title']}"
      puts "   日付: #{r['reportedOn']}"
      puts "   URL: #{r['url']}"
      user = r['user']
      puts "   著者: #{user['longName'] || user['login_name']}" if user
      puts '-' * 60
      puts r['description'] if r['description']
      if r['comments']&.any?
        puts
        puts "💬 コメント (#{r['comments'].size}件)"
        r['comments'].each do |c|
          author = c.dig('user', 'longName') || c.dig('user', 'login_name') || '?'
          puts "  #{author}: #{c['description']&.lines&.first&.strip}"
        end
      end
      puts '=' * 60
    end

    def print_users(users)
      users.each do |u|
        role = u['primaryRole'] || u['roles']&.first || ''
        company = u.dig('company', 'url') ? " (#{u.dig('company', 'url')})" : ''
        puts "👤 #{u['longName'] || u['login_name']} [#{role}]#{company}"
      end
    end

    def print_user_detail(u)
      puts "👤 #{u['longName'] || u['login_name']}"
      puts "   ログイン名: #{u['login_name']}"
      puts "   ロール: #{u['roles']&.join(', ')}"
    end

    def print_practices(practices)
      practices.each do |p|
        puts "📚 #{p['id']}: #{p['title']}"
      end
    end

    def print_progress_report(data)
      puts '=' * 60
      puts "📊 研修生週次レポート #{data['weekStart']} 〜 #{data['weekEnd']}"
      puts '=' * 60
      puts

      (data['trainees'] || []).each do |t|
        activity = t['weeklyActivity'] || {}
        current = t['currentPractice'] || {}
        overall = t['overallProgress'] || {}
        company = t.dig('company', 'name') || '所属なし'
        course = t.dig('course', 'title') || ''

        report_count = activity['reportCount'] || 0
        weekdays = activity['weekdays'] || 5
        percentage = overall['completedPercentage'] || 0

        # ステータス判定
        status = if report_count >= 4
                   '✅'
                 elsif report_count >= 2
                   '⚠️'
                 else
                   '🔴'
                 end

        puts "■ #{t['longName']}（#{company}）- #{course} [#{percentage}%]"
        puts "  日報: #{report_count}/#{weekdays}日 #{status}"

        # 今週の変化
        changes = activity['practiceChanges'] || []
        changes.each do |c|
          case c['status']
          when 'complete'
            puts "  今週: 「#{c['practiceTitle']}」完了 🎉"
          when 'submitted'
            puts "  今週: 「#{c['practiceTitle']}」提出"
          when 'started'
            puts "  今週: 「#{c['practiceTitle']}」着手"
          end
        end

        # 現在のプラクティス
        if current['title']
          days = current['daysOnPractice'] || 0
          slow = if days >= 14
                   ' 🐢'
                 else
                   days >= 7 ? ' ⏳' : ''
                 end
          puts "  現在: 「#{current['title']}」（#{days}日目#{slow}）"
        end

        puts
      end
    end
  end
end
