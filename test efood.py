import pandas as pd

# Load the orders data from a CSV file or a database table
df_orders = pd.read_csv('Assessment exercise dataset - orders.csv')

# Calculate order frequency and order value for each user
df_user = df_orders.groupby('user_id').agg(
    orders=('order_id', 'nunique'),
    total_order_value=('amount', 'sum')
)

# Define quartiles for order frequency and order value
q_orders = df_user['orders'].quantile([0.25, 0.5, 0.75])
q_order_value = df_user['total_order_value'].quantile([0.25, 0.5, 0.75])

# Segment customers based on their order frequency and order value
def segment_user(row):
    if row['orders'] > q_orders[0.75] and row['total_order_value'] > q_order_value[0.75]:
        return 'high_value'
    elif row['orders'] > q_orders[0.5]:
        return 'frequent'
    else:
        return 'other'

df_user['segment'] = df_user.apply(segment_user, axis=1)

# Merge user segments back to the orders data
df_orders = pd.merge(df_orders, df_user[['segment']], on='user_id')

# Calculate the number of breakfast orders for each segment
df_segment = df_orders[df_orders['cuisine'] == 'Breakfast'].groupby('segment').agg(
    breakfast_orders=('order_id', 'nunique')
)

# Calculate the percentage of breakfast orders for each segment
df_segment['percentage'] = df_segment['breakfast_orders'] / df_orders[df_orders['cuisine'] == 'Breakfast']['order_id'].nunique() * 100

# Print the segment data
print(df_segment)
