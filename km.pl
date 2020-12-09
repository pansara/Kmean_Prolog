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
	% Re calculation of Centroids  and store it in UpdatedCentroids
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

