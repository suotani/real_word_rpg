require 'rails_helper'

RSpec.describe User, '銀行機能' do
  subject(:user) { create(:user, balance: 0) }

  describe '#borrow!' do
    context '残枠の範囲内で借入する場合' do
      it '残高と loan_amount が増加する' do
        user.borrow!(100_000)
        expect(user.balance).to eq(100_000)
        expect(user.loan_amount).to eq(100_000)
      end

      it '複数回借入できる' do
        user.borrow!(100_000)
        user.borrow!(150_000)
        expect(user.loan_amount).to eq(250_000)
        expect(user.balance).to eq(250_000)
      end

      it '残枠ちょうどまで借入できる' do
        user.borrow!(User::MAX_LOAN)
        expect(user.loan_amount).to eq(User::MAX_LOAN)
      end
    end

    context '上限を超える場合' do
      it '上限額（300,000円）を超えるとエラー' do
        expect { user.borrow!(User::MAX_LOAN + 1) }.to raise_error(ArgumentError, /借入可能残枠を超えています/)
      end

      it '累計が上限を超えるとエラー' do
        user.borrow!(200_000)
        expect { user.borrow!(150_000) }.to raise_error(ArgumentError, /借入可能残枠を超えています/)
      end

      it 'エラー時に残高・loan_amount は変わらない' do
        expect { user.borrow!(User::MAX_LOAN + 1) }.to raise_error(ArgumentError)
        expect(user.reload.balance).to eq(0)
        expect(user.reload.loan_amount).to eq(0)
      end
    end

    context '0円以下を指定した場合' do
      it 'エラーになる' do
        expect { user.borrow!(0) }.to raise_error(ArgumentError, /1円以上/)
      end
    end
  end

  describe '#repay!' do
    before { user.borrow!(100_000) }

    context '残高・借入残高の範囲内で返済する場合' do
      it '残高と loan_amount が減少する' do
        user.repay!(30_000)
        expect(user.balance).to eq(70_000)
        expect(user.loan_amount).to eq(70_000)
      end

      it '全額返済できる' do
        user.repay!(100_000)
        expect(user.balance).to eq(0)
        expect(user.loan_amount).to eq(0)
        expect(user.in_debt?).to be false
      end

      it '一部返済後に再び借入できる' do
        user.repay!(50_000)
        user.borrow!(50_000)
        expect(user.loan_amount).to eq(100_000)
        expect(user.remaining_loan_capacity).to eq(200_000)
      end
    end

    context '借入残高を超える金額を返済しようとした場合' do
      it 'エラーになる' do
        expect { user.repay!(100_001) }.to raise_error(ArgumentError, /借入残高を超えています/)
      end

      it 'エラー時に残高・loan_amount は変わらない' do
        expect { user.repay!(100_001) }.to raise_error(ArgumentError)
        expect(user.reload.balance).to eq(100_000)
        expect(user.reload.loan_amount).to eq(100_000)
      end
    end

    context '所持金が不足している場合' do
      before { user.deduct!(user.balance) }  # 残高を0にする

      it 'エラーになる' do
        expect { user.repay!(1) }.to raise_error(ArgumentError, /残高が不足しています/)
      end
    end

    context '0円以下を指定した場合' do
      it 'エラーになる' do
        expect { user.repay!(0) }.to raise_error(ArgumentError, /1円以上/)
      end
    end
  end

  describe '#remaining_loan_capacity' do
    it '初期値は MAX_LOAN' do
      expect(user.remaining_loan_capacity).to eq(User::MAX_LOAN)
    end

    it '借入額分だけ減る' do
      user.borrow!(80_000)
      expect(user.remaining_loan_capacity).to eq(User::MAX_LOAN - 80_000)
    end

    it '返済すると残枠が回復する' do
      user.borrow!(80_000)
      user.repay!(30_000)
      expect(user.remaining_loan_capacity).to eq(User::MAX_LOAN - 50_000)
    end
  end
end
