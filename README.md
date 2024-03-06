<details>
<summary>Wrangler Class Documentation</summary>

The `Wrangler` class is a custom extension of the `pd.DataFrame` class with additional functionalities for data preprocessing and analysis.

<details><summary>## Class Attributes</summary>

- `_metadata`: List of metadata attributes preserved in the class.

- **`_constructor`**

  - Description: This property returns a constructor for the class. The constructor is a function that can create a new instance of the class.

  - Returns:
    - Function: A constructor function.
</details>

<details>
<summary>## Methods</summary>

### Initialization

- **`__init__(self, *args, **kwargs)`**:
  
  - Description: Initializes the `Wrangler` object, with an optional `my_attr` attribute.

### Data Preprocessing

- **`strip_dataframe(self)`**

  - Description: This method strips leading and trailing white spaces from both the DataFrame columns and the values within those columns.

  - Note: This method modifies the DataFrame in place.
    
- **`normalize(self, col)`**

  - Description: This method performs normalization on a numerical column in the DataFrame.

  - Parameters:
    - `col`: String: The name of the numerical column to be normalized.

  - Note: This method modifies the DataFrame in place by replacing the values in the specified numerical column with their normalized counterparts.
       
- **`complete_imputation(self)`**

  - Description: This method performs imputation on the entire DataFrame, filling missing values regardless of datatype. Numerical columns are imputed with the mean of the column, while categorical columns are imputed with the mode of the column.

  - Note: This method modifies the DataFrame in place.
    
- **`remove_outlier_iqr(self, column)`**

  - Description: This method uses the Interquartile Range (IQR) method to identify and remove outliers from a numerical column in the DataFrame.

  - Parameters:
    - `column`: String: The name of the numerical column from which outliers are to be removed.

  - Note: This method modifies the DataFrame in place.
    
- **`outlier_limits_iqr(self, column)`**

  - Description: This method produces the upper and lower bound rows of a DataFrame using the Interquartile Range (IQR) method based on a given column.

  - Parameters:
    - `column`: String: The name of the numerical column used to calculate outliers.

  - Returns:
    - DataFrame: Rows of the DataFrame where values are considered outliers based on the IQR method. 
    
- **`show_outlier_rows(self)`**

  - Description: This method displays all rows in the DataFrame that contain outliers using the Interquartile Range (IQR) method.

  - Note: Outliers are determined separately for each numerical column in the DataFrame.

- **`category_datatype(self)`**

  - Description: This method type casts columns with an object datatype into a category datatype.

  - Note: This method modifies the DataFrame in place.
    
- **`turn_null(self, val)`**

  - Description: This method replaces values in a DataFrame that represent an unknown value but are not recorded as null (e.g., '-', '?', '*') with NaN.

  - Parameters:
    - `val`: The value to be replaced with NaN.

  - Note: This method modifies the DataFrame in place.

- **`null_percent(self)`**

  - Description: Outputs the percentage of null values in each column of the DataFrame.

- **`drop_null_by_percent(self, percent)`**

  - Description: Drops columns in a DataFrame that have a percentage of null values greater than or equal to the specified threshold.

  - Parameters:
    - `percent`: Float: The percentage threshold above which columns will be dropped. Expressed as a value between 0 and 100.

  - Note: This method modifies the DataFrame in place.
      
- **`bool_datatype(self, column, true_value, false_value)`**

  - Description: This method type casts an object datatype into a boolean datatype based on specified true and false values.

  - Parameters:
    - `column` (str): The name of the column in the DataFrame.
    - `true_value`: The value in the column to be considered as True.
    - `false_value`: The value in the column to be considered as False.

  - **Note**: This method modifies the DataFrame in place.

### Data Analysis

- **`dataframe_analysis(self)`**:
  
  - Description: Provides descriptive statistics, checks for null values, and duplicated rows.
    
- **`identify_columns(self)`**:
  
  - Description: Identifies numerical and categorical columns.
    
- **`column_analysis(self)`**

  - Description: This method identifies and analyzes columns in the DataFrame, categorizing them into numerical and categorical columns, and provides additional insights such as high cardinality categorical columns and numerical columns treated as categorical.

  - Returns:
    - `category_columns`: List of Strings: Names of categorical columns.
    - `numerical_columns`: List of Strings: Names of purely numerical columns.
    - `category_with_hi_cardinality`: List of Strings: Names of categorical columns with high cardinality.
    
  - Note: High cardinality is defined as having more than 50 unique values.
  
- **`categorical_column_summary(self, column_name, plot=False)`**

  - Description: This method provides a summary of a categorical column in the DataFrame.

  - Parameters:
    - `column_name`: String: The name of the categorical column to summarize.
    - `plot`: Boolean (default: False): If True, a count plot of the categorical column will be displayed.

  - Note: This method prints the count and percentage ratio of each category in the specified categorical column.
      
- **`numerical_column_summary(self, column, plot=False)`**

  - Description: This method provides a summary of a numerical column in the DataFrame.

  - Parameters:
    - `column`: String: The name of the numerical column to summarize.
    - `plot`: Boolean (default: False): If True, a histogram of the numerical column will be displayed along with the summary statistics.

  - Note: This method prints the summary statistics including count, mean, standard deviation, minimum, 5th, 10th, 20th, 30th, 40th, 50th (median), 60th, 70th, 80th, 90th, 95th, and 99th percentiles.

  
- **`target_cross_analysis_cat(self, target, cat_col)`**

  - Description: This method cross-examines the relationship between a target column (numerical) and a categorical column.

  - Parameters:
    - `target`: String: The name of the numerical target column.
    - `cat_col`: String: The name of the categorical column.

  - Note: This method prints the mean of the target column grouped by the categories in the specified categorical column.
       
- **`target_cross_analysis_num(self, target, num_col)`**

  - Description: This method cross-examines the relationship between a target column and a numerical column, regardless of the datatype of the target column.

  - Parameters:
    - `target`: String: The name of the target column.
    - `num_col`: String: The name of the numerical column.

- **`counter(self, column)`**

  - Description: This method prints a dictionary containing the unique values of a specified column along with the number of occurrences of each value.

  - Parameter(s):
    - `column`: String: The name of the column for which unique values and their occurrences are counted.
</details>
</details>

<details>
<summary>Graphs Class Documentation</summary>

The `Graphs` class provides a variety of methods for visualizing data using seaborn and matplotlib libraries. This class is designed to facilitate the creation of different types of plots for exploratory data analysis.

...

</details>
