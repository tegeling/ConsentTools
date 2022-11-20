/**
 * @description       :
 * @author            : dirk.gronert@salesforce.com
 * @group             :
 * @last modified on  : 11-14-2022
 * @last modified by  : tegeling@salesforce.com
 **/
public with sharing class CDPService {
  private static String PRODUCT_BROWSE_ENGAGEMENT_TEMPALATE_SQL = 'select {0} from ssot__ProductBrowseEngagement__dlm AS b, ssot__GoodsProduct__dlm AS p WHERE {1} AND b.ssot__ProductId__c = p.ssot__Id__c ORDER BY b.ssot__EngagementDateTm__c DESC';

  private static Map<String, String> PRODUCT_BROWSE_ENGAGEMENT_TEMPALATE_SQL_FIELDS = new Map<String, String>{
    'b.ssot__Id__c' => 'id',
    'p.ssot__Name__c' => 'product',
    'b.ssot__EngagementDateTm__c' => 'eventDateTime',
    'b.ssot__ProductViewURL__c' => 'url',
    'b.ssot__ProductCategoryName__c' => 'category',
    'p.ssot__BrandId__c' => 'brand'
  };

  /**
   *
   * @param fields
   * @return  `List<String>`
   */
  private static List<String> getSQLFields(Map<String, String> fields) {
    List<String> sqlFields = new List<String>();
    for (String sqlField : fields.keySet())
      sqlFields.add(
        String.format(
          '{0} AS {1}',
          new List<String>{ sqlField, fields.get(sqlField) }
        )
      );
    return sqlFields;
  }

  /**
   *
   * @param engagementVehicles
   * @return  `String`
   */
  private static String constructBroductBrowseEngagementSQLWhereClause(
    String sqlWhere,
    List<String> engagementVehicles
  ) {
    if (engagementVehicles != null && engagementVehicles.size() > 0) {
      List<String> sqlWhereEngagementVehicleList = new List<String>();
      for (String engagementVehicle : engagementVehicles)
        if (String.isNotBlank(engagementVehicle))
          sqlWhereEngagementVehicleList.add(
            'ssot__ProductCategoryName__c = \'' +
            engagementVehicle +
            '\''
          );
      if (sqlWhereEngagementVehicleList.size() > 0)
        sqlWhere +=
          (String.isBlank(sqlWhere) ? '' : ' AND ') +
          String.join(sqlWhereEngagementVehicleList, ' OR ') +
          ' ) ';
    }
    return sqlWhere;
  }

  /**
   *
   * @param email
   * @param engagementVehicles
   * @return  `String`
   */
  private static String constructBroductBrowseEngagementSQL(
    String email,
    List<String> engagementVehicles
  ) {
    List<String> sqlFields = getSQLFields(
      PRODUCT_BROWSE_ENGAGEMENT_TEMPALATE_SQL_FIELDS
    );
    String sqlWhere = constructBroductBrowseEngagementSQLWhereClause(
      'b.Email__c = \'' +
      email +
      '\'',
      engagementVehicles
    );
    return String.format(
      PRODUCT_BROWSE_ENGAGEMENT_TEMPALATE_SQL,
      new List<Object>{ String.join(sqlFields, ', '), sqlWhere }
    );
  }

  /**
   *
   * @param ctxId the reference record the query is relying on (an salesforce recordId)
   * @param ctxEmailField the field name which has the email adress stored
   * @param engagementVehicles
   * @return  `List<Map<String, Object>>`
   */
  @AuraEnabled
  public static List<Map<String, Object>> getWebSiteEngagements(
    String ctxId,
    String ctxEmailField,
    List<String> engagementVehicles
  ) {
    List<Map<String, Object>> result = new List<Map<String, Object>>();
    if (String.isNotBlank(ctxId) && String.isNotBlank(ctxEmailField)) {
      SobjectType recSObjType;
      try {
        recSObjType = Id.valueOf(ctxId).getSobjectType();
      } catch (System.StringException e) {
        System.debug('No valid Id provided');
      }
      if (recSObjType != null) {
        Schema.DescribeSObjectResult objDescRes = recSObjType.getDescribe();
        if (objDescres.isAccessible()) {
          Map<String, Schema.SObjectField> fieldMap = objDescRes.fields.getMap();
          if (fieldMap.containsKey(ctxEmailField)) {
            Schema.DescribeFieldResult fieldDescRes = fieldMap.get(
                ctxEmailField
              )
              .getDescribe();
            if (fieldDescRes.isAccessible()) {
              sObject s = Database.query(
                String.format(
                  'SELECT {0} FROM {1} WHERE Id = {2} LIMIT 1',
                  new List<Object>{
                    ctxEmailField,
                    Id.valueOf(ctxId).getSobjectType(),
                    '\'' +
                    ctxId +
                    '\''
                  }
                )
              );
              if (s != null) {
                String email = (String) s.get(ctxEmailField);
                if (String.isNotBlank(email)) {
                  // this is the interesting part and must be adjusted for other use cases!
                  ConnectApi.CdpQueryInput query = new ConnectApi.CdpQueryInput();
                  query.sql = constructBroductBrowseEngagementSQL(
                    email,
                    engagementVehicles
                  );
                  System.debug('# SQL Query: ' + query.sql);
                  result.addAll(
                    constructReturn(ConnectApi.CdpQuery.queryAnsiSqlV2(query))
                  );
                } else {
                  System.debug(
                    'Context record (' +
                    ctxId +
                    ') has no email value'
                  );
                }
              } else {
                System.debug('No context record found for ' + ctxId);
              }
            } else {
              System.debug(
                'User has no permission to access the field ' + ctxEmailField
              );
            }
          }
        } else {
          System.debug(
            'User has no permission to access the object ' +
            objDescRes.getName()
          );
        }
      }
    } else {
      System.debug('ctxId as well as ctxEmailField must be passed');
    }
    return result;
  }

  /**
   *
   * @param data
   * @return  `List<Map<String, Object>>`
   */
  private static List<Map<String, Object>> constructReturn(
    ConnectApi.CdpQueryOutputV2 data
  ) {
    System.debug('#### data rowCount: ' + data.rowCount);
    List<Map<String, Object>> result = new List<Map<String, Object>>();
    Map<String, ConnectApi.CdpQueryMetadataItem> meta = data.metadata;
    for (ConnectApi.CdpQueryV2Row rowRaw : data.data) {
      Map<String, Object> rawDTO = new Map<String, Object>();
      for (String metaKey : meta.keySet()) {
        ConnectApi.CdpQueryMetadataItem metaValue = meta.get(metaKey);
        rawDTO.put(metaKey, rowRaw.rowData.get(metaValue.placeInOrder));
      }
      result.add(rawDTO);
    }
    System.debug('#### ConnectApi result: ' + result.size());
    for (Map<String, Object> cur : result) {
      System.debug('#### metaKey: ' + cur.toString());
    }
    return result;
  }
}
