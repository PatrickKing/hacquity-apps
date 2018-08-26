class VendorReviewTextSearch < ActiveRecord::Migration[5.2]
  def up


    # Postgres full-text search index:
    execute <<-SQL

      ALTER TABLE vendor_reviews ADD COLUMN text_search_document tsvector;

      CREATE INDEX vendor_reviews_fts_idx ON vendor_reviews USING GIN (text_search_document);

      CREATE TRIGGER vendor_reviews_fts_update BEFORE INSERT OR UPDATE
      ON vendor_reviews FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(text_search_document, 'pg_catalog.english', title, body, vendor_name, vendor_services);

    SQL

  end

  def down
    execute <<-SQL

      DROP TRIGGER vendor_reviews_fts_update ON vendor_reviews;
      DROP INDEX vendor_reviews_fts_idx;
      ALTER TABLE vendor_reviews DROP COLUMN text_search_document;

    SQL
  end

end
