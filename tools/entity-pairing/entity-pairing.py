#!/usr/bin/env python
# coding=UTF-8

import argparse


def retrieve_entities(text, entity_tag):
    entities = []
    start_tag = "<" + entity_tag + ">"
    end_tag = "</" + entity_tag + ">"
    search_start_index = 0

    while True:
        start_tag_index = text.find(start_tag, search_start_index)
        if start_tag_index < 0:
            return entities

        end_tag_index = text.find(end_tag, search_start_index)
        if end_tag_index < 0:
            return entities

        entity_start_index = start_tag_index + len(start_tag)
        entity = text[entity_start_index:end_tag_index]

        entities.append((entity, entity_start_index))
        search_start_index = end_tag_index + len(end_tag)


def pair_entities(sources, targets, maximum_distance, default_entity):
    pairs = []

    for source_entity in sources:
        target_entity_with_distance = find_closest_target_entity(source_entity, targets)
        if target_entity_with_distance is None:
            pairs.append((source_entity[0], default_entity))
        else:
            if maximum_distance < 0 or target_entity_with_distance[1] < maximum_distance:
                pairs.append((source_entity[0], target_entity_with_distance[0][0]))
            else:
                pairs.append((source_entity[0], default_entity))

    return pairs


def find_closest_target_entity(source_entity, targets):
    lowest_distance = -1
    closest_entity = None
    for target_entity in targets:
        distance = compute_distance_between_entities(source_entity, target_entity)
        if lowest_distance < 0:
            lowest_distance = distance
            closest_entity = (target_entity, lowest_distance)
        else:
            if distance < lowest_distance:
                lowest_distance = distance
                closest_entity = (target_entity, lowest_distance)
            else:
                return closest_entity
    return closest_entity


def compute_distance_between_entities(first_entity, second_entity):
    if first_entity[1] < second_entity[1]:
        return second_entity[1] - (first_entity[1] + len(first_entity[0]))
    else:
        return first_entity[1] - (second_entity[1] + len(second_entity[0]))


def export_entity_pairs(entities, separator, file_output):
    for pair in entities:
        file_output.write(pair[0])
        file_output.write(separator)
        file_output.write(pair[1].lower())
        file_output.write("\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='PLots paths from CSV files with pose information')
    parser.add_argument('-i', metavar='INPUT_FILE', type=str, required=True,
                        help='Input file with entities annotated with XML tags')
    parser.add_argument('-o', metavar='OUTPUT_FILE', type=str, required=False, default='entity-pairs.txt',
                        help='Output file name in which it will be output the pairs of entities')
    parser.add_argument('-l', metavar='OUTPUT_FILE_PAIR_SEPARATOR', type=str, required=False, default=' -> ',
                        help='Delimiter for a token group when pairing source and target entities.')
    parser.add_argument('-s', metavar='SOURCE_ENTITY', type=str, required=False, default='PART',
                        help='XML tag for the source entity of the pair')
    parser.add_argument('-t', metavar='TARGET_ENTITY', type=str, required=False, default='TOOL',
                        help='XML tag for the target entity of the pair')
    parser.add_argument('-m', metavar='TARGET_ENTITY_MAXIMUM_CHARACTERS_DISTANCE', type=int, required=False, default=-300,
                        help='Maximum number of tokens that a given target entity can be from the source entity')
    parser.add_argument('-d', metavar='TARGET_ENTITY_DEFAULT', type=str, required=False, default='universal gripper',
                        help='Default value for the target entity when it is not available in the annotated text')
    parser.add_argument('-e', metavar='TOKEN_GROUP_DELIMITER', type=str, required=False, default='.',
                        help='Delimiter for a token group when pairing source and target entities.')
    args = parser.parse_args()

    with open(args.i) as input_file:
        with open(args.o, "w") as output_file:
            text = input_file.read()

            if len(args.e) > 0:
                sentences = text.split(args.e)
            else:
                sentences = [text]

            for sentence in sentences:
                source_entities = retrieve_entities(sentence, args.s)
                target_entities = retrieve_entities(sentence, args.t)
                entities_pairs = pair_entities(source_entities, target_entities, args.m, args.d)
                export_entity_pairs(entities_pairs, args.l, output_file)

    exit(0)
