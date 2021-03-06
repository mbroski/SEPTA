//
//  TripStartCommand.swift
//  SeptaSchedule
//
//  Created by Mark Broski on 8/13/17.
//  Copyright © 2017 Mark Broski. All rights reserved.
//

import Foundation
/*
 SELECT
 S.stop_id stopId,
 S.stop_name stopName,
 cast (S.stop_lat as decimal) stopLatitude,
 cast (S.stop_lon as decimal) stopLongitude,
 case when S.wheelchair_boarding = '1' then 1 else 0  end wheelchairBoarding,
 MAX(CASE WHEN T.service_id = '1'
 THEN 1 else 0 END) weekdayService,
 MAX(CASE WHEN
 T.service_id = '2'
 THEN 1  else 0 END) saturdayService,
 MAX(CASE WHEN
 T.service_id = '3'
 THEN 1  else 0 END) AS sundayService
 FROM trips_bus T
 JOIN routes_bus R
 ON T.route_id = R.route_id
 JOIN stops_bus S
 ON R.route_id = T.route_id
 WHERE T.route_id = '44' AND direction_id = '1'
 GROUP BY S.stop_id, S.stop_name, S.stop_lat, S.stop_lon;
 */

public class TripStartCommand: BaseCommand {
    public typealias TripStartCommandCompletion = ([Stop]?, Error?) -> Void
    public static let sharedInstance = TripStartCommand()

    private override init() {}

    public func stops(forTransitMode transitMode: TransitMode, forRoute route: Route, completion: @escaping TripStartCommandCompletion) {
        let sqlQuery = TripStartSQLQuery(transitMode: transitMode, route: route)
        retrieveResults(sqlQuery: sqlQuery, userCompletion: completion) { (statement) -> [Stop] in
            var stops = [Stop]()
            for row in statement {
                if
                    let col0 = row[0], let stopIdInt = col0 as? Int64,
                    let col1 = row[1], let stopName = col1 as? String,
                    let col2 = row[2], let stopLatitude = col2 as? Double,
                    let col3 = row[3], let stopLongitude = col3 as? Double,
                    let col4 = row[4], let wheelchairBoardingInt = col4 as? Int64,
                    let col5 = row[5], let weekdayServiceInt = col5 as? Int64,
                    let col6 = row[6], let saturdayServiceInt = col6 as? Int64,
                    let col7 = row[7], let sundayServiceInt = col7 as? Int64 {
                    let stopId = Int(stopIdInt)
                    let wheelchairBoarding = wheelchairBoardingInt == 1
                    let weekdayService = weekdayServiceInt == 1
                    let saturdayService = saturdayServiceInt == 1
                    let sundayService = sundayServiceInt == 1
                    let stop = Stop(stopId: stopId, stopName: stopName, stopLatitude: stopLatitude, stopLongitude: stopLongitude, wheelchairBoarding: wheelchairBoarding, weekdayService: weekdayService, saturdayService: saturdayService, sundayService: sundayService)
                    stops.append(stop)
                }
            }
            return stops
        }
    }
}
