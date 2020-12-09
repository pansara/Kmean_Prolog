%%%%Kmean can also add max itteration 
kmean(DataSet, 1, [DataSet]).
kmean(DataSet, K, DataSet) :- 
      length(DataSet, L),
      L == K,
      !.
kmean(DataSet, K, Clusters):-
      length(DataSet, L),
      L @> K, !,
      init(DataSet, K, Centroids),
      begin_clustering(DataSet, Centroids, K, [], ClusterMap).
	  
%%%%begin_clustering
%% Input: DataSet: [[1,2], [3, 4], [2, 3]]
%% InitialClusters: [] OR [ C1 = [[1, 2], [3, 4]], C2=[[2,3]] ]
%% Centroids : [cs1, cs2]
begin_clustering(DataSet, Centroids, K, PreviousClusterMap, ResultantClusterMap) :-
	get_cluster_map(DataSet, Centroids, UpdatedClusterMap),
	PreviousClusterMap \== UpdatedClusterMap, !, 
	centroids_calc(UpdatedClusterMap, DataSet, K, UpdatedCentroids),
	begin_clustering(DataSet, UpdatedCentroids, K, PreviousClusterMap, ResultantClusterMap)
	

%% Remove Everything above this to test it, since things above are not yet fully implemented

%%% get_cluster_map 
%(Outputs an array of Clusters)
get_cluster_map([Vertex | DataSet], Centroids, [IndexOfCluster | ClusterMap]) :-
        !,
        current_prolog_flag(max_integer, SYSTEM_MAX),
        get_label(Vertex, Centroids, SYSTEM_MAX, [], Centroid),
		nth0(IndexOfCluster, Centroids, Centroid),
		get_cluster_map(DataSet, Centroids, ClusterMap).
get_cluster_map([],_, []).
	

%% Get labels returns an array whose index represents the ith DataPoint 
%% while the value at ith position is the Index of Centroid ORCluster it belongs to
get_label(Vertex, [Centroid|Centroids], CurrentMin, R, Result) :-
		euclidean_distance(Vertex, Centroid, D),
		D @< CurrentMin,
		!,
		get_label(Vertex, Centroids, D, Centroid, Result).
get_label(Vertex, [_ | Centroids], CurrentMin, R, Result) :-
	!,
	get_label(Vertex, Centroids, CurrentMin, R, Result).
get_label(_, [], _, Result, Result).


euclidean_distance([X|T1], [Y|T2], Distance) :- 
	calculation(T1, T2, (Y-X)^2, S),
	Distance is sqrt(S). 

calculation([], [], I, I).
calculation([X|T1], [Y|T2], I0, I+I0) :-
	calculation(T1, T2, (Y-X)^2, I).
		



%%%% init()
%% init takes in DataSet and K and returns a list containing k initial centroids
%% Return value looks something like this: 
%% [[x1, y1], [x2, y2],...... ,[xk, yk]]
%% Consider the case when DataSet is []
init(DataSet, 0, []):- !.
init(DataSet, K, [H|Centroids]) :- 
        K > 0,
        length(DataSet, L),
        random(0, L, Index),
        nth0(Index, DataSet, H),
        delete(DataSet, H, UpdatedDataset),
        I is K-1,
        init(UpdatedDataset, I, Centroids).



%%%% centroids_calc()
%% takes in the cluster map, datasets and number of clusters and gives away the new 
%% calculated centroids
%% Return value looks something like this if we have 3 clusters:
%% [[x1, y1], [x2, y2], [x3, y3]]
%% These are the three newly calculated centroids
centroids_calc(ClusterMap, DataSet, K, Centroids) :-
	cluster_mapping(ClusterMap, DataSet, 0, K, NewClusters),
	maplist(ReCentroid, NewClusters, Centroids).



%%%% cluster_mapping()
%% takes the array of clusters and dataset and returs the list clustered into K parts
cluster_mapping(_, _, K, K, []) :- !.
cluster_mapping(ClusterMap, DataSet, Counter, K, [InitialCluster | ResultantCluster]) :-
	cluster_mapping_helper(ClusterMap, DataSet, Counter, 0, InitialCluster),
	SubCounter is Counter + 1,
	cluster_mapping(ClusterMap, DataSet, SubCounter, K, ResultantCluster).



%%%% cluster_mapping_helper()
%% this is the helper funciton for the above mapping function
%% it takes in the array of clusters and dataset and assign the datapoint from the dataset 
%% to a particular cluster depending on the list of clusters
cluster_mapping_helper([Counter | ClusterMap], DataSet, Counter, Index, [IndexElement | Resultant]) :-
	nth0(Index, DataSet, IndexElement),
	NextIndex is Index + 1, !,
	cluster_mapping_helper(ClusterMap, DataSet, Counter, NextIndex, Resultant).
cluster_mapping_helper([_ | ClusterMap], DataSet, Counter, Index, Resultant) :-
	NextIndex is Index + 1, !,
	cluster_mapping_helper(ClusterMap, DataSet, Counter, NextIndex, Resultant).
cluster_mapping_helper([], _, _, _, []).
	
