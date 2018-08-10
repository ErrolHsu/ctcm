class Admin::TrialsController < AdminController

  expose(:trials) { Trial.all }
  expose(:props) { {trials: build_trials_hash}.to_json }

  def index

  end

  def option
    begin
      trial = Trial.find_by(id: params[:id].to_i)
      trial.status = params[:status]
      trial.save
      render json: {trial: trial.translate.attributes, message: 'success'}, status: 200
    rescue
      render json: {message: 'Fail'}, status: 500
    end
  end

  private

  def build_trials_hash
    hash = Trial.all.reduce({}) {|result, trial| result.merge(trial.id => trial.translate.attributes) }
    hash
  end

end
