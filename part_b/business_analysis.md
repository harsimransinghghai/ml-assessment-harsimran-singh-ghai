## B1. Problem Formulation
### (a) Machine Learning Formulation

This problem can be formulated as a supervised regression problem, where the objective is to predict the number of items sold for a given store, promotion, and time period.

- **Target Variable:** items_sold

- **Input Features:**
  - Store characteristics: store_size, location_type, competition_density
  - Promotion information: promotion_type
  - Temporal features: month, day_of_week, is_weekend, is_festival
  - Store identifier (store_id) to capture store-specific effects

This is a regression problem because the target variable is continuous. The model aims to estimate expected sales volume under different promotional and contextual conditions.

### (b) Why Items Sold is a Better Target than Revenue

Using items_sold is more reliable than revenue because revenue is affected by price changes, discounts, and product mix. Promotions such as discounts may reduce revenue per item while increasing volume, making revenue an inconsistent measure of promotion effectiveness.

Items sold directly reflects customer response to promotions, which is the primary objective in this scenario.

This illustrates the broader principle of target variable alignment: the target variable must directly represent the business objective. Choosing an indirect or noisy target can lead to misleading model outcomes.

### (c) Alternative Modelling Strategy

Instead of a single global model, a more effective approach is a segmented or hierarchical modelling strategy.

Options include:

- Training separate models for different location types (urban, semi-urban, rural), or
- Using a global model with interaction terms (e.g., promotion × location)

This accounts for heterogeneity in customer behaviour across stores, ensuring that the model captures location-specific responses to promotions and improves predictive accuracy.

## B2. Data and EDA Strategy
### (a) Data Joining and Dataset Design

The final dataset should be constructed by joining:

- Transactions table → base table (contains items_sold)
- Store attributes → joined using store_id
- Promotion details → joined using promotion_type or promotion_id
- Calendar table → joined using transaction_date

The grain of the dataset should be:
👉 One row per store per time period (e.g., per day or per month)

Before modelling, aggregations may include:

- Total items sold per store per month
- Average competition density
- Promotion indicators per period
- Temporal features derived from date

This ensures consistency and avoids duplicate or fragmented observations.

### (b) Exploratory Data Analysis (EDA)

Key analyses include:

- **Distribution of Items Sold**
  - Detect skewness and outliers
  - Decide if transformation is required

- **Promotion Performance Analysis**
  - Compare items_sold across promotion types
  - Identify high-performing promotions

- **Time Series Analysis**
  - Plot sales over time
  - Identify trends and seasonality

- **Correlation Analysis**
  - Identify relationships between numerical variables
  - Detect multicollinearity

- **Sales by Store Segment**
  - Compare performance across location types and store sizes
  - Validate need for segmentation

These insights inform feature engineering and modelling strategy.

### (c) Handling Promotion Imbalance

If 80% of transactions occur without promotions, the dataset is imbalanced.

This can cause the model to:

- Bias predictions toward non-promotion cases
- Underestimate the impact of promotions

To address this:

- Apply sample weighting to emphasise promotion cases
- Use balanced sampling techniques
- Ensure all promotion types are sufficiently represented

This improves the model’s ability to learn the true effect of promotions.

## B3. Model Evaluation and Deployment
### (a) Train-Test Split and Evaluation Metrics

A time-based split should be used, where earlier data is used for training and the most recent data for testing.

A random split is inappropriate because it introduces data leakage, allowing future information to influence training.

Evaluation metrics:

- **RMSE (Root Mean Squared Error):**
  - Penalises large errors
  - Useful for identifying significant prediction deviations

- **MAE (Mean Absolute Error):**
  - Provides average prediction error
  - Easier to interpret in business terms (units of items sold)

Together, these metrics provide a balanced view of model performance.

### (b) Explaining Model Recommendations

Feature importance can be used to explain why the model recommends different promotions for the same store across months.

For example:

In December, features such as is_festival and seasonal trends may dominate
In March, factors like competition_density or store characteristics may be more influential

By analysing feature importance, we can identify which variables drive predictions in each scenario and communicate these insights clearly to the marketing team.

### (c) Deployment Strategy

The deployment process includes:

- **Model Saving**
  - Save the trained pipeline using joblib or pickle

- **Data Preparation**
  - Collect new monthly data
  - Apply the same preprocessing steps (feature engineering, encoding, scaling)

- **Prediction Generation**
  - Input new data into the saved model
  - Generate promotion recommendations for each store

- **Monitoring**
  - Track performance metrics (RMSE, MAE) over time
  - Detect model drift or degradation

- **Retraining**
  - Retrain periodically (e.g., quarterly)
  - Or when performance drops significantly

This ensures the system remains accurate and adaptable to changing business conditions.