require 'csv'

# FXトレードボット(実資金を扱う)の稼働状況をまとめて見る管理者専用ダッシュボード。
# 各戦略の稼働状況(enabled)・発注サイズ(size)・損切り(stop_loss_yen)はこの画面から
# そのまま編集できる。docs/fx_trade_bot.md の注意点を参照。緊急停止は各戦略の
# enabled を false にすること。
class Admin::FxBotSettingsController < Admin::ApplicationController
  CSV_HEADERS = %w[日時 取引日 戦略 イベント 理由 サイド サイズ 価格 決済損益 取引余力 メモ].freeze

  def show
    @settings = FxBotSetting.order(:strategy)
    @recent_logs = FxTradeLog.order(created_at: :desc).limit(20)
    @latest_margin_log = FxTradeLog.where(event: 'close').where.not(margin: nil).order(created_at: :desc).first
    @latest_regime = FxMarketRegime.latest
  end

  def update
    setting = FxBotSetting.find(params[:id])
    if setting.update(fx_bot_setting_params)
      redirect_to admin_fx_bot_setting_path, notice: "#{setting.strategy} の設定を更新しました"
    else
      redirect_to admin_fx_bot_setting_path, alert: setting.errors.full_messages.join('、')
    end
  end

  # FxTradeLog全件をCSVでダウンロードする。GMOコインの約定履歴API(/v1/latestExecutions)は
  # 直近1日分しか返さないため、より長期間の実績を確認・分析したい場合はこちら
  # (アプリ自身が記録してきたログ、GMO側の保持期間に依存しない)を使う。
  def export_trade_logs
    logs = FxTradeLog.order(:created_at)

    csv_data = CSV.generate(encoding: 'UTF-8') do |csv|
      csv << CSV_HEADERS
      logs.each do |log|
        csv << [
          log.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          log.trade_date,
          log.strategy,
          log.event_label,
          log.reason_label,
          log.side,
          log.size,
          log.price,
          log.loss_gain,
          log.margin,
          log.note
        ]
      end
    end

    send_data "﻿#{csv_data}",
              filename: "fx_trade_logs_#{Date.today}.csv",
              type: 'text/csv; charset=UTF-8'
  end

  private

  def fx_bot_setting_params
    params.require(:fx_bot_setting).permit(:enabled, :size, :stop_loss_yen)
  end
end
