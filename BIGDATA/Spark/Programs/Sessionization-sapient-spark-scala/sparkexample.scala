import scala.language.implicitConversions
import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.sql.functions.{col, concat, exp, first, lag, lit, sum, when}
import org.apache.spark.sql.expressions.Window

object sparkexample extends App{

  val spark = SparkSession.builder
    .master("local[*]")
    .appName("Spark-scala Example")
    .getOrCreate()

  val df = spark.read.option("header", true)
    .option("delimiter",",")
    .csv("C:\\psnl\\input\\users_input.csv")
    .select(col("Timestamp")
      .cast("timestamp"),col("userid"))

  val  windowSpec = Window.partitionBy("userid")
       .orderBy("Timestamp")

  df.show()

  val df_final = df.withColumn("lag_Timestamp", lag("Timestamp", 1).over(windowSpec))
    .withColumn("time_diff", ((col("Timestamp").cast("long") - col("lag_Timestamp").cast("long")) / (60*30)))
    .na.fill(0)
    .withColumn("is_new_session", when(col("time_diff") > 1, 1).otherwise(0) )
    .withColumn("temp_session_id", sum(col("is_new_session")).over(windowSpec))
    .withColumn("first_Timestamp", first(col("Timestamp")).over(Window.partitionBy("userid", "temp_session_id").orderBy("Timestamp")))
    .withColumn("time_diff2", ((col("Timestamp").cast("long") - col("first_Timestamp").cast("long"))/(60 * 60 * 2)).cast("int"))
    .withColumn("session_id", concat(col("userid"),lit("-"),(col("time_diff2") + col("temp_session_id"))))
    .drop("lag_Timestamp","time_diff", "is_new_session", "temp_session_id", "first_Timestamp", "time_diff2" )

  df_final.show()

  df_final.write.parquet("C:\\psnl\\output\\output_parquet\\")

}
