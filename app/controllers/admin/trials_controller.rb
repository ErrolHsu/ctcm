class Admin::TrialsController < AdminController

  expose(:trials) { Trial.all }
  expose(:undone_trials) { Trial.undone  }
  expose(:props) { {trials: build_trials_hash(Trial.undone)}.to_json }

  def index

  end

  def shipping
    begin
      trial = Trial.find_by(id: params[:id].to_i)
      trial.shipping
      # TrialMailer.notify_shipped(Trial.last).deliver!
      trials = get_trials_by_filter(params['filter'])
      render json: {trials: build_trials_hash(trials), message: 'success'}, status: 200
    rescue
      render json: {message: '伺服器錯誤'}, status: 500
    end
  end

  def request_reject
    begin
      trial = Trial.find_by(id: params[:id].to_i)
      trial.request_reject
      # TODO 寄信
      trials = get_trials_by_filter(params['filter'])
      render json: {trials: build_trials_hash(trials), message: 'success'}, status: 200
    rescue
      render json: {message: '伺服器錯誤'}, status: 500
    end
  end

  def reset
    begin
      trial = Trial.find_by(id: params[:id].to_i)
      trial.reset
      trials = get_trials_by_filter(params['filter'])
      render json: {trials: build_trials_hash(trials), message: 'success'}, status: 200
    rescue
      render json: {message: '伺服器錯誤'}, status: 500
    end
  end

  # def option
  #   begin
  #     trial = Trial.find_by(id: params[:id].to_i)
  #     trial.status = params['status']
  #     if params['status'] == 'request'
  #       trial.executed = false
  #     else
  #       trial.executed = true
  #     end
  #     trial.save

  #     trials = get_trials_by_filter(params['filter'])
  #     render json: {trials: build_trials_hash(trials), message: 'success'}, status: 200
  #   rescue
  #     render json: {message: '伺服器錯誤'}, status: 500
  #   end
  # end

  def filter
    begin
      trials = get_trials_by_filter(params['filter'])
      render json: {trials: build_trials_hash(trials), message: 'success'}, status: 200
    rescue
      render json: {message: '伺服器錯誤'}, status: 500
    end
  end

  private

  def build_trials_hash(trial_scope)
    hash = trial_scope.reduce({}) {|result, trial| result.merge(trial.id => trial.attributes) }
    hash
  end

  def get_trials_by_filter(filter)
    case filter
    when 'all'
      Trial.all
    when 'undone'
      Trial.undone
    when 'reject'
      Trial.be_reject
    when 'shipped'
      Trial.shipped
    end
  end

end
