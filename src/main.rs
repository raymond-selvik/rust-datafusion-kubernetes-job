use datafusion::prelude::*;

#[tokio::main]
async fn main() -> () {
  df_example().await;
}

async fn df_example() -> datafusion::error::Result<()> {
    // create the dataframe
    let ctx = SessionContext::new();
    let df = ctx.read_csv("data/test.csv", CsvReadOptions::new()).await?;

    df.show_limit(100).await?;

    let df = df.select(vec![col("a"), col("b")])?.with_column("sum", col("a") + col("b"))?;
    df.show_limit(100).await?;

    Ok(())
}

async fn sql_example() -> datafusion::error::Result<()> {
    let ctx = SessionContext::new();
    ctx.register_csv("test", "data/test.csv", CsvReadOptions::new()).await?;
  
    let df = ctx.sql("SELECT a, b, (a + b) as sum FROM test LIMIT 100").await?;
  
    // execute and print results
    df.show().await?;
    Ok(())
}